require_relative 'drawable'
class Rectangle < Drawable
    attr_accessor :color
    def initialize game, color=Gosu::Color::BLACK, rectangle = nil, &constraint
        super(game, rectangle, &constraint)
        @color = color
    end
    def draw
        Gosu.draw_rect(@rectangle.x, @rectangle.y, @rectangle.width, @rectangle.height, @color)
    end
end