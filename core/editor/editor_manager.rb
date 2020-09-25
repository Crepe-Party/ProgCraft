require 'pp'
require_relative 'elements/editor_ui'
require_relative '../events/events_manager'
require_relative '../level'
require_relative '../game_objects/player'
class EditorManager
    attr_reader :window, :editor_ui, :events_manager, :ready_for_constraints
    attr :level, :player
    def initialize window
        @window = window

        @planned_actions = {}
        @keys_down = []

        @ready_for_constraints = false

        @events_manager = EventsManager.new window
        @editor_ui = EditorUI.new self, Rectangle2.new(0,0)
        @level = Level.new
        @player = Player.new(600, 300)

        @ready_for_constraints = true
    end
    def update dt
        update_planned_actions
        @editor_ui.update dt
        @events_manager.update
    end
    def render
        # final draw
        elements_to_draw = @editor_ui.render.flatten
        elements_to_draw.each{|drawable| drawable.draw_with_clipping}
        # temp TODO remove
        clip_rect =  @editor_ui.sub_elements[:map_editor].rectangle
        Gosu.clip_to clip_rect.x, clip_rect.y, clip_rect.width, clip_rect.height do
            x = 5
            grid_size = 50
            while x < window.width do
                Gosu.draw_line(x, 0, Gosu::Color.new(200,200,200), x, window.height, Gosu::Color.new(200,200,200))
                x+=grid_size
            end
            y = 65
            while y < window.height do
                Gosu.draw_line(0, y, Gosu::Color.new(200,200,200), window.width, y, Gosu::Color.new(200,200,200))
                y+=grid_size
            end
            @level.render 0 if @level_available
            @player.draw
        end
    end
    def apply_constraints
        return unless @ready_for_constraints
        #start applying constraints to children
        @editor_ui.rectangle.width = window.width
        @editor_ui.rectangle.height = window.height
        @editor_ui.apply_constraints
    end
    def load_map path_file
        @level_available = @level.load path_file
        @player.set_pos @level.maps[0].player_spawn.x, @level.maps[0].player_spawn.y unless @level_available.nil?
    end

    def add_event element, type, options = {}, &handler
        @events_manager.add_event(element, type, options, handler)
    end

    def plan_action duration, &handler
        duration = 0 if duration == :next_frame
        #insert
        @planned_actions[(Time.now.to_f*1000 + duration*1000).ceil] = handler
        #sort
        @planned_actions = @planned_actions.keys.sort.map{|key| [key, @planned_actions[key]]}.to_h
    end
    def update_planned_actions
        return if @planned_actions.empty?
        time = Time.now.to_f*1000
        to_remove = []
        @planned_actions.each do |stamp, handler|
            if stamp <= time
                to_remove.push stamp
                handler.call
            else
                break
            end
        end
        to_remove.each{|stamp| @planned_actions.delete(stamp)}
    end
end