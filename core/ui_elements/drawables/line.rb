require_relative 'drawable'
class Line < Drawable
    attr_accessor :color
    def initialize root, color=Gosu::Color::BLACK, &constraint
        @color = color
        super(root, &constraint)
    end
    def draw
        Gosu.draw_line(@rectangle.x, @rectangle.y, @color, @rectangle.right, @rectangle.bottom, @color)
    end
end