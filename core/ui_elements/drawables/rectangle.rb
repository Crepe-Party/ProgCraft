# rectangle
class Rectangle
    attr_accessor :x, :y, :width, :height, :color
    def initialize x, y, width, height, color
        @x, @y, @width, @height, @color = x, y, width, height, color
    end
    def draw
        Gosu.draw_rect(@x, @y, @width, @height, @color)
    end
end