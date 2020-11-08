require_relative '../drawables/rectangle'
require_relative '../drawables/text'
class TextInput < UIElement
    attr_accessor :border_width
    attr_reader :placeholder
    def initialize root, placeholder: nil, border_width: 5, cursor_width: 2, border_color: Gosu::Color::BLACK, bg_color: Gosu::Color::GRAY, cursor_color: Gosu::Color::RED, text_color: Gosu::Color::WHITE, &constraint
        super root, &constraint
        @border_width = border_width
        @cursor_width = cursor_width
        @placeholder = placeholder
        @cursor_position = 0
        self.background_color = border_color;

        @sub_elements[:inside_rect] = Rectangle.new(@root, bg_color){@rectangle.relative_to(x: @border_width, y:@border_width, width: -2*@border_width, height: -2*@border_width)}
        @sub_elements[:text] = Text.new(@root, @placeholder || "", color: text_color, center_text: false){@sub_elements[:inside_rect].rectangle}
        @sub_elements[:cursor] = Rectangle.new(@root, cursor_color).constrain do
            text_elem = @sub_elements[:text]
            str_at_pos = text_elem.string[0...@cursor_position]
            width_at_pos = text_elem.font.text_width(str_at_pos, text_elem.scale)

            text_elem.rectangle.relative_to(x: width_at_pos).assign!(width: @cursor_width)
        end
    end
    def placeholder= text
        @placeholder = text
    end
    def text_elem
        @sub_elements[:text]
    end
end