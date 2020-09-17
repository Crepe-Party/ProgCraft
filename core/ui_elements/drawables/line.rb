# line
class Line
    attr_accessor :x_start, :y_start, :x_end, :y_end, :color
    def initialize x_start, y_start, x_end, y_end, color=Gosu::Color::BLACK
        @x_start, @y_start, @x_end, @y_end, @color = x_start, y_start, x_end, y_end, color
    end
    def draw
        Gosu.draw_line(@x_start, @y_start, Gosu::Color::BLACK, @x_end, @y_end, Gosu::Color::BLACK)
    end
end