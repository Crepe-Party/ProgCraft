require_relative 'drawable'
require_relative '../../tools/vector'
class Text < Drawable
    attr_accessor :string, :font, :color, :scale, :center_text
    def initialize game, rectangle = nil, string = "", font: Gosu::Font.new(20), color: Gosu::Color::BLACK, scale: 1, center_text: true
        @string, @font, @color, @scale, @center_text = string, font, color, scale, center_text
        super game, rectangle
    end
    def draw
        x_pos = @rectangle.x
        y_pos = @rectangle.y
        if center_text
            text_width = @font.text_width @string, @scale
            x_pos += ((@rectangle.width - text_width) / 2)
            y_pos += ((@rectangle.height - @font.height) / 2)
        end
        @font.draw_text(@string, x_pos, y_pos, 1, @scale, @scale, @color)
    end
end