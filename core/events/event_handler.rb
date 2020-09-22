require_relative 'event'
class EventHandler < Event
    def initialize type, element, handler
        super type, element
        @handler = handler
    end

    def trigger evt
        @handler.call evt if @element.rectangle.contains? evt[:position]
    end
end