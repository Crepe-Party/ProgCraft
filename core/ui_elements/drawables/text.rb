require_relative 'drawable'
require_relative '../../tools/vector'
class Text < Drawable
    attr_accessor :string, :font, :color, :scale, :center_text
    DEFAULT_FONT_SIZE = 20
    def initialize root, string = "", font: nil, font_size: DEFAULT_FONT_SIZE, color: Gosu::Color::BLACK, scale: 1, center_text: :middle, overflow: :shown, &constraint
        @string, @color, @scale, @center_text = string, color, scale, center_text
        @font = font || Gosu::Font.new(font_size, name: "Consolas")
        @overflow_hidden = (overflow == :hidden)
        super(root, &constraint)
    end
    def draw
        x_pos = @rectangle.x
        y_pos = @rectangle.y + 2 #+2 because idk
        if center_text
            text_width = @font.text_width @string, @scale
            x_pos += ((@rectangle.width - text_width) / 2) unless center_text == :vertical
            y_pos += ((@rectangle.height - @font.height) / 2) unless center_text == :horizontal
        end
        @font.draw_text(@string, x_pos, y_pos, 0, @scale, @scale, @color)
    end
end