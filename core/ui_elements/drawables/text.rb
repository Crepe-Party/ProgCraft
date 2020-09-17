# text
class Text
    attr_accessor :text, :x, :y, :width, :height, :font, :color, :scale
    def initialize text, x, y, width, height, font, color=Gosu::Color::BLACK, scale=1
        @text, @x, @y, @width, @height, @font, @color, @scale = text, x, y, width, height, font, color, scale
    end
    def draw
        @font.draw_text(@text, @x, @y, 1, @scale, @scale, @color)
    end
end