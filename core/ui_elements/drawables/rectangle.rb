require_relative 'drawable'
class Rectangle < Drawable
    attr_accessor :color
    def initialize game, rectangle = nil, color=Gosu::Color::BLACK
        super game, rectangle
        @color = color
    end
    def draw
        Gosu.draw_rect(@rectangle.x, @rectangle.y, @rectangle.width, @rectangle.height, @color)
    end
end