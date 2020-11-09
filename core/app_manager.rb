require 'pp'
require_relative 'events/events_manager'
require_relative 'tools/window_manager'
class AppManager
    attr_reader :window, :main_ui, :events_manager, :window_manager, :busy, :ready_for_constraints, :text_input_receiver
    def initialize window, main_ui_class:
        @planned_actions = {}
        @busy=false
        @text_input_receiver = nil
        @window_manager = WindowManager.new
        @events_manager = EventsManager.new window
        @window = window

        @ready_for_constraints = false
        @main_ui = main_ui_class.new self
        @ready_for_constraints = true

        @busy_string = "Busy..."
    end
    def update dt
        update_planned_actions
        @main_ui.update dt
        @events_manager.update
    end
    def render
        # final draw
        elements_to_draw = @main_ui.render.flatten
        elements_to_draw.each{|drawable| drawable.draw_with_clipping}
    end
    def apply_constraints
        return unless @ready_for_constraints
        #start applying constraints to children
        @main_ui.rectangle.width = window.width
        @main_ui.rectangle.height = window.height
        @main_ui.apply_constraints
    end    
    def busy= value
        @busy = value
        if @busy    
            @main_ui.sub_elements[:busy_loader]= Class.new(UIElement) do 
                def build
                    self.background_color=Gosu::Color.rgba(255, 255, 255, 150)
                    @sub_elements[:background_text] = Text.new(@root, @busy_string, center_text: true, color: Gosu::Color::BLACK, font_size: 50){@rectangle}
                end
            end.new(self){Rectangle2.new(0,0,self.window.width, self.window.height)}
            @main_ui.apply_constraints
        else
            @main_ui.sub_elements.delete(:busy_loader)
        end
    end
    def plug_text_input element
        unplug_text_input(@text_input_receiver) if @text_input_receiver
        @text_input_receiver = element
        @window.text_input = Gosu::TextInput.new
        element.text_input_plugged(@window.text_input) if defined? element.text_input_plugged

        @window.text_input
    end
    def unplug_text_input element=nil
        if element && element != @text_input_receiver
            element.text_input_unplugged if defined? element.text_input_unplugged
            return
        end
        @text_input_receiver.text_input_unplugged if defined? element.text_input_unplugged
        @text_input_receiver = nil
        @window.text_input = nil
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