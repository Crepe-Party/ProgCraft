class Scrollable < Element
    attr_reader :scroll_direction
    public
    def initialize
        super
        scroll_direction= :vertical
    end
    def build

    end
    def scroll_direction= scroll_direction
        @scroll_direction = scroll_direction
    end
end