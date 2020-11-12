class EventHandler
    attr_reader :window, :element
    def initialize window, element, handler
        @window, @element, @handler = window, element, handler
    end
    def check
    end
    def trigger(params={})
        @handler.call(params)
    end
end
