require_relative 'drawable'
class Line < Drawable
    attr_accessor :color
    def initialize game, color=Gosu::Color::BLACK, rectangle = nil, &constraint
        @color = color
        super(game, rectangle, &constraint)
    end
    def draw
        Gosu.draw_line(@rectangle.x, @rectangle.y, @color, @rectangle.right, @rectangle.bottom, @color)
    end
end