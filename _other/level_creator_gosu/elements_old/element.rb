class Element
    attr_accessor :x
    attr_accessor :y
    attr_accessor :parent
    def initialize (x:0, y:0, parent: false)
        @elements = {}
        @x, @y, @parent = x, y, parent
    end
    public
    def update
        @elements.each do |elem_name, elem|
            elem.update
        end
    end
    def draw
        @elements.each do |elem_name, elem|
            elem.draw
        end
    end
end