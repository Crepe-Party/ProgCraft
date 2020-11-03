
require_relative 'event_handler'
require_relative 'mouse_events'
module EventHandlers
    class Drop < MouseHandler
        def check filename
            is_inside = mouse_inside?
            trigger({filename: filename}) if is_inside
        end
    end    
end