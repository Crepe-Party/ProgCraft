require 'pp'
require_relative 'elements/game_ui'
require_relative '../events/events_manager'
require_relative '../level'
require_relative '../game_objects/player'
require_relative '../tools/window_manager'
class GameManager
    attr_reader :window, :game_ui, :events_manager, :window_manager, :busy, :ready_for_constraints
    attr :level, :player
    def initialize window
        @window = window

        @busy=false
        @planned_actions = {}
        @keys_down = []

        @window_manager = WindowManager.new
        @events_manager = EventsManager.new window
        
        @ready_for_constraints = false
        @game_ui = GameUI.new self
        @ready_for_constraints = true
        
        @level = Level.new
        @player = Player.new(600, 300)
    end
    def update dt
        update_planned_actions
        @game_ui.update dt
        @events_manager.update
    end
    def render
        # final draw
        elements_to_draw = @game_ui.render.flatten
        elements_to_draw.each{|drawable| drawable.draw_with_clipping}
    end
    def apply_constraints
        return unless @ready_for_constraints
        #start applying constraints to children
        @game_ui.rectangle.width = window.width
        @game_ui.rectangle.height = window.height
        @game_ui.apply_constraints
    end
    def load_map path_file
        @level_available = @level.load path_file
        @player.set_pos @level.maps[0].robert_spawn.x, @level.maps[0].robert_spawn.y unless @level_available.nil?
    end
    def load_program path_file
    
    end
    def save_program path_file
        
    end
    def busy= value
        @busy = value
        if @busy    
            @game_ui.sub_elements[:busy_loader]= Class.new(UIElement) do 
                def build
                    self.background_color=Gosu::Color.rgba(255, 255, 255, 150)
                    @sub_elements[:background_text] = Text.new(@game, "Loading...", center_text: true, color: Gosu::Color::BLACK, font_size: 50){@rectangle}
                end
            end.new(self){Rectangle2.new(0,0,self.window.width, self.window.height)}
            @game_ui.apply_constraints
        else
            @game_ui.sub_elements.delete(:busy_loader)
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