
require_relative 'event_handler'
module EventHandlers
    class ButtonHandler < EventHandler
        def button_down? id
            @window.button_down?(@button) || @window.keys_down.include?(id)
        end
    end
    class ButtonDown < ButtonHandler
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
    class ButtonUp < ButtonHandler
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