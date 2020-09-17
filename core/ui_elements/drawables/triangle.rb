# triangle
class Triangle
    attr_accessor :x, :y, :width, :height, :color, :angle
    def initialize x, y, width, height, color, angle=0
        @x, @y, @width, @height, @color, @angle = x, y, width, height, color, angle
    end
    def draw
        Gosu.draw_triangle(@x, @y, @color, @x+@width, @y, @color, @x+(@width/2), @y+@height, @color)
    end
end