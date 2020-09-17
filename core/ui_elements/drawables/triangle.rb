# triangle
class Triangle
    attr_accessor :x, :y, :width, :height, :color, :angle
    def initialize x1, y1, x2, y2, x3, y3, color=Gosu::Color::BLACK, angle=0
        @x1, @y1, @x2, @y2, @x3, @y3, @color, @angle = x1, y1, x2, y2, x3, y3, color, angle
    end
    def draw
        Gosu.draw_triangle(@x1, @y1, @color, @x2, @y2, @color, @x3, @y3, @color)
    end
end