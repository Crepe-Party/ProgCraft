require_relative 'keyboard_events'
require_relative 'mouse_events'
class EventsManager
    attr_accessor :available
    def initialize window
        @window = window
        @events = []
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
        when :button_up
            event = EventHandlers::ButtonUp.new @window, element, handler, options[:button]
        when :button_press
            event = EventHandlers::ButtonPress.new @window, element, handler, options[:button]
        end
        @events.push event
    end
end
