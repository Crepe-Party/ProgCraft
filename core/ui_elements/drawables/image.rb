require_relative 'drawable'
class Image < Drawable
    def initialize game, source, rectangle = nil, &contraint
        super game, rectangle, &contraint
        @image = Gosu::Image.new source
    end
    def draw
        @image.draw(@rectangle.x, @rectangle.y, 0)
    end
end