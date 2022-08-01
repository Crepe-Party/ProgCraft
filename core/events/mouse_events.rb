require_relative 'event_handler'
require_relative 'keyboard_events'
module EventHandlers
    class MouseHandler < EventHandler        
        def mouse_inside?
            @element.rectangle.includes?  @window.mouse_x, @window.mouse_y
        end
    end
    class MouseEnter < MouseHandler
        def check
            is_inside = mouse_inside?
            res = trigger if is_inside && !@is_inside               
            @is_inside = is_inside
            return res
        end
    end
    class MouseLeave < MouseHandler
        def check
            is_outside = !mouse_inside?
            res = trigger if is_outside && !@is_outside               
            @is_outside = is_outside
            return res
        end
    end
    class MouseDown < MouseHandler
        def initialize window, element, handler, button, stop_propagation: true
            @button_event = ButtonDown.new window, element, ->(event = {}){
                next unless mouse_inside?()
                event[:position] = @window.mouse_pos
                trigger(event)
            }, button
            super window, element, handler, stop_propagation: stop_propagation
        end
        def check
            @button_event.check
        end
    end
    class MouseUp < MouseHandler
        def initialize window, element, handler, button, stop_propagation: true
            @button_event = ButtonUp.new window, element, handler, button
            super window, element, handler, stop_propagation: stop_propagation
        end
        def check
            res = @button_event.check if mouse_inside?()
            return res
        end
    end
    class MouseDrag < MouseHandler
        def initialize window, element, handler, button, stop_propagation: true
            @ms_down_evt = MouseDown.new(window, element, ->(evt=nil){@dragging = true}, button)
            @btn_up_evt = ButtonUp.new(window, element, ->(evt=nil){@dragging = false}, button)
            super window, element, handler, stop_propagation: stop_propagation
        end
        def check
            res = nil
            @ms_down_evt.check
            @btn_up_evt.check
            if @dragging
                mouse_pos = @window.mouse_pos
                res = trigger(position: mouse_pos, last_position: @last_mouse_pos, position_diff: mouse_pos - @last_mouse_pos) if @last_mouse_pos
                @last_mouse_pos = mouse_pos
            elsif @last_mouse_pos
                @last_mouse_pos = nil
            end
            return res
        end
    end
end