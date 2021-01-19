
require_relative 'event_handler'
require_relative 'mouse_events'
module EventHandlers
    class Drop < MouseHandler
        def check filename
            is_inside = mouse_inside?
            res = trigger({filename: filename}) if is_inside
            return res
        end
    end
    class Submit < EventHandler
    end
end