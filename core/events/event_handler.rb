class EventHandler
    def initialize window, element, handler
        @window, @element, @handler = window, element, handler
    end
    def check
    end
    def trigger(params={})
        @handler.call(params)
    end
end