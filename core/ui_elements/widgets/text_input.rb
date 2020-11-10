require_relative '../drawables/rectangle'
require_relative '../drawables/text'
class TextInput < UIElement
    attr_accessor :border_width
    attr_reader :placeholder
    def initialize root, placeholder: nil, border_width: 5, cursor_width: 2, border_color: Gosu::Color::BLACK, bg_color: Gosu::Color::GRAY, cursor_color: Gosu::Color::RED, text_color: Gosu::Color::WHITE, selection_color: Gosu::Color::rgba(128, 128, 255, 100), &constraint
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
            puts "focus on text input"
            @root.plug_text_input(self)

        end
    end
    def text_input_plugged text_input
        @text_input_instance = text_input
        @text_input_instance.text = "wowowowo"
        apply_constraints
    end
    def text_input_unplugged
        puts "hey"
        @text_input_instance = nil
        apply_constraints
    end
    def apply_constraints *args
        @sub_elements[:cursor].rectangle.assign!(width: 0, height: 0)
        @sub_elements[:selection].rectangle.assign!(width: 0, height: 0)
        if @text_input_instance
            text = self.text_elem.string
            cursor_offset = offset_at_text_pos(text, @text_input_instance.caret_pos)
            
            if @text_input_instance.selection_start == @text_input_instance.caret_pos
                #cursor
                @sub_elements[:cursor].rectangle = self.text_elem.rectangle
                .relative_to(x: cursor_offset - (@cursor_width / 2))
                    .assign!(width: @cursor_width)
            else
                #selection
                selection_offset = offset_at_text_pos(text, @text_input_instance.selection_start)
                selection = [cursor_offset, selection_offset].sort!
                @sub_elements[:selection].rectangle = self.text_elem.rectangle
                .relative_to(x: selection[0])
                .assign!(width: selection[1] - selection[0])
            end
        end
        super *args
    end
    def offset_at_text_pos text, pos
        self.text_elem.font.text_width(text[0...pos], 1)
    end
    def update dt
        super dt
        if @text_input_instance && (
            @text_input_instance.text != @value ||
            @text_input_instance.caret_pos != @text_input_caret_pos
        )
            puts "salut"
            on_text_change(@text_input_instance.text)
            @text_input_caret_pos = @text_input_instance.caret_pos 
            apply_constraints
        end
    end
    def on_text_change new_text
        @value = new_text
        self.text_elem.string = new_text
    end
    def placeholder= text
        @placeholder = text
    end
    def text_elem
        @sub_elements[:text]
    end
end