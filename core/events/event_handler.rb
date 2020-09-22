class EventHandler 
    attr_reader :type
    def initialize type, element
        
    end
    def initialize type, element, handler
        @type, @element, @handler = type, element, handler
    end

    def trigger evt
        @handler.call evt if @element.rectangle.contains? evt[:position]
    end
end