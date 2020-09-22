class UIElement
    attr_accessor :x
    attr_accessor :y
    attr_accessor :sub_elements
    def initialize (window, x:0, y:0, parent: nil)
        @x, @y, @window = x, y, window
        @elements = {}
    end
    def build

    end
    public
    def update
        @elements.each do |elem_name, elem|
            elem.update
        end
    end
    def draw
        @sub_elements.each do |elem_name, elem|
            elem.draw
        end
    end
end