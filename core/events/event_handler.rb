class EventHandler
    attr_reader :window, :element
    def initialize window, element, handler, stop_propagation: true
        @window, @element, @handler, @stop_propagation = window, element, handler, stop_propagation
    end
    def check
    end
    def trigger(params={})
        @handler.call(params)
    end
end
