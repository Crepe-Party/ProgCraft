require_relative 'drawable'
class Rectangle < Drawable
    attr_accessor :color
    def initialize root, color = Gosu::Color::BLACK, &constraint
        super(root, &constraint)
        @color = color
    end
    def draw
        Gosu.draw_rect(@rectangle.x, @rectangle.y, @rectangle.width, @rectangle.height, @color)
    end
end