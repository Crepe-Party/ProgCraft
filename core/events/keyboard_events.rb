
require_relative 'event_handler'
module EventHandlers
    class ButtonDown < EventHandler
        def initialize window, element, handler, button
            @button = button
            super window, element, handler
        end
        def check
            is_button_down = @window.button_down?(@button)
            trigger if is_button_down && !@is_button_down              
            @is_button_down = is_button_down
        end
    end
    class ButtonUp < EventHandler
        def initialize window, element, handler, button
            @button = button
            super window, element, handler
        end
        def check
            is_button_up = !@window.button_down?(@button)
            trigger if is_button_up && !@is_button_up              
            @is_button_up = is_button_up
        end
    end
end