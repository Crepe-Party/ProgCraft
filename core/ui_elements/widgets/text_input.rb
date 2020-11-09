require_relative '../drawables/rectangle'
require_relative '../drawables/text'
class TextInput < UIElement
    attr_accessor :border_width
    attr_reader :placeholder
    def initialize root, placeholder: nil, border_width: 5, cursor_width: 2, border_color: Gosu::Color::BLACK, bg_color: Gosu::Color::GRAY, cursor_color: Gosu::Color::RED, text_color: Gosu::Color::WHITE, selection_color: Gosu::Color::rgba(128, 128, 150, 100), &constraint
        super root, &constraint
        @border_width = border_width
        @cursor_width = cursor_width
        @placeholder = placeholder
        @cursor_position = 0
        self.background_color = border_color;

        @sub_elements[:inside_rect] = Rectangle.new(@root, bg_color){@rectangle.relative_to(x: @border_width, y:@border_width, width: -2*@border_width, height: -2*@border_width)}
        @sub_elements[:text] = Text.new(@root, @placeholder || "", color: text_color, center_text: false){@sub_elements[:inside_rect].rectangle}
        @sub_elements[:cursor] = Rectangle.new(@root, cursor_color)
        @sub_elements[:selection] = Rectangle.new(@root, selection_color)
    end
    def build
        super
        self.add_event(:click) do |evt|
            puts "salut"
        end
    end
    def apply_constraints *args
        super *args
=begin
        text = @text_input.text
        @font.draw_text(text, 50, 50, 0, 1, 1, Gosu::Color::WHITE)
        cursor_offset = offset_at_text_pos text, @text_input.caret_pos

        if @text_input.selection_start == @text_input.caret_pos
            #cursor
            Gosu.draw_rect(49 + cursor_offset, 50, 2, 30, Gosu::Color::RED)
        else
            #selection
            selection_offset = offset_at_text_pos text, @text_input.selection_start
            selection = [cursor_offset, selection_offset].sort!
            Gosu.draw_rect(50 + selection[0], 50, selection[1] - selection[0], 30, Gosu::Color::rgba(255,255,255,128))
        end


        text_elem = @sub_elements[:text]
        str_at_pos = text_elem.string[0...@cursor_position]
        width_at_pos = text_elem.font.text_width(str_at_pos, text_elem.scale)
        @sub_elements[:cursor].rectangle = text_elem.rectangle.relative_to(x: width_at_pos).assign!(width: @cursor_width)
=end
    end
    def update dt
        super dt
        if @text_input_instance && (
            @text_input_instance.text != self.text_elem.string ||
            @text_input_instance.caret_pos != @text_input_caret_pos
        )
            puts "salut"
            self.text_elem.string = @text_input_instance.text
            @text_input_caret_pos = @text_input_instance.caret_pos 
            apply_constraints
        end
    end
    def placeholder= text
        @placeholder = text
    end
    def text_elem
        @sub_elements[:text]
    end
end