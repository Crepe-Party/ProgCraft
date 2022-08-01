require_relative 'keyboard_events'
require_relative 'mouse_events'
require_relative 'special_events'
class EventsManager
    attr_accessor :available
    def initialize window
        @window = window
        @events = []
        @custom_events = []
        # define if the events can be listened to
        @available = true;
    end
    def update
        events_stopped = []
        if @available
            @events.reverse.each do |event|
                unless events_stopped.include? event.class
                    if event.check
                        events_stopped << event.class if event.stop_propagation
                    end
                end
            end
        end
    end
    def add_event element, type, options, handler, stop_propagation: true
        event = nil
        case type
        when :mouse_enter
            event = EventHandlers::MouseEnter.new @window, element, handler, stop_propagation: stop_propagation
        when :mouse_leave
            event = EventHandlers::MouseLeave.new @window, element, handler, stop_propagation: stop_propagation
        when :mouse_down
            event = EventHandlers::MouseDown.new @window, element, handler, options[:button], stop_propagation: stop_propagation
        when :mouse_up
            event = EventHandlers::MouseUp.new @window, element, handler, options[:button], stop_propagation: stop_propagation
        when :mouse_drag
            event = EventHandlers::MouseDrag.new @window, element, handler, options[:button], stop_propagation: stop_propagation
        when :button_down
            event = EventHandlers::ButtonDown.new @window, element, handler, options[:button], stop_propagation: stop_propagation
        when :click
            event = EventHandlers::MouseDown.new @window, element, handler, options[:button] || Gosu::MS_LEFT, stop_propagation: stop_propagation
        when :button_up
            event = EventHandlers::ButtonUp.new @window, element, handler, options[:button], stop_propagation: stop_propagation
        when :button_press
            event = EventHandlers::ButtonPress.new @window, element, handler, options[:button], stop_propagation: stop_propagation
        end

        if event
            @events.push(event) 
            return event
        end 

        #special events
        case type
        when :drop
            event = EventHandlers::Drop.new @window, element, handler, stop_propagation: stop_propagation
        when :submit
            event = EventHandlers::Submit.new @window, element, handler, stop_propagation: stop_propagation
        when :change
            event = EventHandlers::Change.new @window, element, handler, stop_propagation: stop_propagation
        end

        if event
            @custom_events.push(event)
            return event
        end
    end
    def remove_events element
        @events.delete_if{|elem| elem.element == element}
        @custom_events.delete_if{|elem| elem.element == element}
    end

    #event interfaces
    def drop filename
        return unless @available
        @custom_events.each do |event|
            event.check(filename) if event.class == EventHandlers::Drop
        end
    end
    def submit input
        return unless @available
        events = @custom_events.select{|evt| evt.class == EventHandlers::Submit && evt.element == input}
        events.each{|ev| ev.trigger(value: input.value, input: input)} if events
    end
    def change input
        return unless @available
        events = @custom_events.select{|evt| evt.class == EventHandlers::Change && evt.element == input}
        events.each{|ev| ev.trigger(value: input.value, input: input)} if events
    end
end
