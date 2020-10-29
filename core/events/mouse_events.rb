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
            trigger if is_inside && !@is_inside               
            @is_inside = is_inside
        end
    end
    class MouseLeave < MouseHandler
        def check
            is_outside = !mouse_inside?
            trigger if is_outside && !@is_outside               
            @is_outside = is_outside
        end
    end
    class MouseDown < MouseHandler
        def initialize window, element, handler, button
            @button_event = ButtonDown.new window, element, handler, button
            super window, element, handler
        end
        def check            
            @button_event.check if mouse_inside?()
        end
    end
    class MouseUp < MouseHandler
        def initialize window, element, handler, button
            @button_event = ButtonUp.new window, element, handler, button
            super window, element, handler
        end
        def check
            @button_event.check if mouse_inside?()
        end
    end
    class MouseDrag < MouseHandler
        def initialize window, element, handler, button
            @ms_down_evt = MouseDown.new window, element, handler, button
            @ms_up_evt <<<<<<<<<<<<<<<<<<<<<<<il faut faire ça svp
            super window, element, handler
        end
        def check
    end
end