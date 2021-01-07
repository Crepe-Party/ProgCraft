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
        @events.each(&:check) if @available
    end
    def add_event element, type, options, handler
        event = nil
        case type
        when :mouse_enter
            event = EventHandlers::MouseEnter.new @window, element, handler
        when :mouse_leave
            event = EventHandlers::MouseLeave.new @window, element, handler
        when :mouse_down
            event = EventHandlers::MouseDown.new @window, element, handler, options[:button]
        when :mouse_up
            event = EventHandlers::MouseUp.new @window, element, handler, options[:button]
        when :mouse_drag
            event = EventHandlers::MouseDrag.new @window, element, handler, options[:button]
        when :button_down
            event = EventHandlers::ButtonDown.new @window, element, handler, options[:button]
        when :click
            event = EventHandlers::MouseDown.new @window, element, handler, options[:button] || Gosu::MS_LEFT
        when :button_up
            event = EventHandlers::ButtonUp.new @window, element, handler, options[:button]
        when :button_press
            event = EventHandlers::ButtonPress.new @window, element, handler, options[:button]
        end

        if event
            @events.push(event) 
            return event
        end 

        #special events
        case type
        when :drop
            event = EventHandlers::Drop.new @window, element, handler
        when :submit
            event = EventHandlers::Submit.new @window, element, handler
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
        event = @custom_events.find{|evt| evt.class == EventHandlers::Submit && evt.element == input}
        event.trigger({value: input.value, input: input}) if event
    end
end
