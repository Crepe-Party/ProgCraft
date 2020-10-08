require 'pp'
require_relative 'elements/editor_ui'
require_relative '../events/events_manager'
require_relative '../level'
require_relative '../game_objects/player'
require_relative '../tools/window_manager'
class EditorManager
    attr_reader :window, :editor_ui, :events_manager, :window_manager, :busy, :ready_for_constraints
    attr :level, :player
    def initialize window   
        @planned_actions = {}
        @keys_down = []
        @busy=false
        @window_manager = WindowManager.new
        @events_manager = EventsManager.new window
        @window = window

        @window_manager = WindowManager.new
        @events_manager = EventsManager.new window

        @ready_for_constraints = false
        @editor_ui = EditorUI.new self
        @ready_for_constraints = true
        
        @level = Level.new
        @player = Player.new(600, 300)
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
            @level.render 0 unless @level_available.nil?
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
        @player.set_pos @level.maps[0].robert_spawn.x, @level.maps[0].robert_spawn.y unless @level_available.nil?
    end
    def save_map path_file
        @level.save path_file
    end
    
    def busy= value
        @busy = value
        if @busy    
            @editor_ui.sub_elements[:busy_loader]= Class.new(UIElement) do 
                def build
                    self.background_color=Gosu::Color.rgba(255, 255, 255, 150)
                    @sub_elements[:background_text] = Text.new(@root, "Loading...", center_text: true, color: Gosu::Color::BLACK, font_size: 50){@rectangle}
                end
            end.new(self){Rectangle2.new(0,0,self.window.width, self.window.height)}
            @editor_ui.apply_constraints
        else
            @editor_ui.sub_elements.delete(:busy_loader)
        end
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