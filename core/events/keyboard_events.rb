
require_relative 'event_handler'
module EventHandlers
    class ButtonHandler < EventHandler
        def button_down? ids
            ids = [ids] unless ids.instance_of? Array
            ids.each do |id|
                id = Gosu.char_to_button_id(id) if id.instance_of? String #key from char
                return true if @window.keys_down.include? id
            end
            false
        end
    end
    class ButtonDown < ButtonHandler
        def initialize window, element, handler, button, stop_propagation: true
            @button = button
            super window, element, handler, stop_propagation: stop_propagation
        end
        def check
            is_button_down = button_down?(@button)
            res = trigger if is_button_down && !@is_button_down
            @is_button_down = is_button_down
            return res
        end
    end
    class ButtonPress < ButtonHandler
        def initialize window, element, handler, button, stop_propagation: true
            @button = button
            super window, element, handler, stop_propagation: stop_propagation
        end
        def check
            res = trigger if button_down?(@button)
            return res
        end
    end 
    class ButtonUp < ButtonHandler
        def initialize window, element, handler, button, stop_propagation: true
            @button = button
            super window, element, handler, stop_propagation: stop_propagation
        end
        def check
            is_button_up = !button_down?(@button)
            res = trigger if is_button_up && !@is_button_up              
            @is_button_up = is_button_up
            return res
        end
    end
end