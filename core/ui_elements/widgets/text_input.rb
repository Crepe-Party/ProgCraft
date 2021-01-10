require_relative '../drawables/rectangle'
require_relative '../drawables/text'
class TextInput < UIElement
    attr_accessor :border_width
    attr_reader :placeholder, :value
    def initialize root, placeholder: nil, border_width: 5, cursor_width: 2, border_color: Gosu::Color::BLACK, bg_color: Gosu::Color::GRAY, cursor_color: Gosu::Color::RED, text_color: Gosu::Color::WHITE, placeholder_color: Gosu::Color::rgba(255,255,255,128), selection_color: Gosu::Color::rgba(128, 128, 255, 100), &constraint
        super root, &constraint
        @border_width = border_width
        @cursor_width = cursor_width
        @placeholder = placeholder
        @placeholder_color = placeholder_color
        @value = ""
        @text_color = text_color
        @cursor_position = 0
        self.background_color = border_color;

        @sub_elements[:inside_rect] = Rectangle.new(@root, bg_color){ @rectangle.relative_to(x: @border_width, y:@border_width, width: -2 * @border_width, height: -2 * @border_width) }
        @sub_elements[:text] = Text.new(@root, @placeholder || "", color: placeholder_color, center_text: :vertical, overflow: :hidden){ @sub_elements[:inside_rect].rectangle }
        @sub_elements[:cursor] = Rectangle.new @root, cursor_color
        @sub_elements[:selection] = Rectangle.new @root, selection_color
    end
    def build
        super
        self.add_event(:click){ |evt| self.focus evt[:position] }
    end
    def text_input_plugged text_input
        @text_input_instance = text_input
        @text_input_instance.text = self.value
        self.caret_pos = @text_input_caret_pos if @text_input_caret_pos
        apply_constraints
    end
    def text_input_unplugged
        @text_input_instance = nil
        apply_constraints
    end
    def unplug
        @root.unplug_text_input self
    end
    def apply_constraints *args
        @sub_elements[:cursor].rectangle.assign! width: 0, height: 0 
        @sub_elements[:selection].rectangle.assign! width: 0, height: 0
        if @text_input_instance
            text = self.text_elem.string
            cursor_offset = offset_at_text_pos text, @text_input_instance.caret_pos
            
            if @text_input_instance.selection_start == @text_input_instance.caret_pos
                #cursor
                @sub_elements[:cursor].rectangle = self.text_elem.rectangle
                    .relative_to(x: cursor_offset - (@cursor_width / 2))
                    .assign!(width: @cursor_width)
            else
                #selection
                selection_offset = offset_at_text_pos text, @text_input_instance.selection_start 
                selection = [cursor_offset, selection_offset].sort!
                @sub_elements[:selection].rectangle = self.text_elem.rectangle
                    .relative_to(x: selection[0])
                    .assign!(width: selection[1] - selection[0])
            end
        end
        super *args
    end
    def offset_at_text_pos text, pos
        self.text_elem.font.text_width text[0...pos], 1 
    end
    def text_pos_at_offset text, offset
        final_pos = 0
        text.length.downto(0) do |pos|
            break final_pos = pos + 1 if offset > offset_at_text_pos(text, pos)
        end
        final_pos
    end
    def update dt
        super dt
        if @text_input_instance && (
            @text_input_instance.text != @value ||
            @text_input_instance.caret_pos != @text_input_caret_pos
        )
            on_text_change(@text_input_instance.text)
            @text_input_caret_pos = @text_input_instance.caret_pos 
            apply_constraints
        end
    end
    def on_text_change new_text
        @value = new_text
        if new_text == ""
            self.text_elem.string = @placeholder
            self.text_elem.color = @placeholder_color
        else
            self.text_elem.string = new_text
            self.text_elem.color = @text_color
        end
    end
    def value= text
        text_val = text.to_s
        if @text_input_instance
            @text_input_instance.text = text_val 
        else
            @value = text_val
            on_text_change text_val
        end
    end
    def focus position = nil
        puts "focus on text input"
        if position
            new_caret_pos = text_pos_at_offset(self.value, position.x - self.text_elem.rectangle.x)
            self.caret_pos = new_caret_pos
        end
        @root.plug_text_input(self)# unless @text_input_instance
    end
    def clear
        self.value = ""
    end
    def submit
        @root.events_manager.submit(self)
    end
    def caret_pos= new_pos
        @text_input_caret_pos = new_pos
        if @text_input_instance
            @text_input_instance.caret_pos = new_pos
            @text_input_instance.selection_start = new_pos
        end
        apply_constraints
    end
    def placeholder= text
        @placeholder = text
    end
    def text_elem
        @sub_elements[:text]
    end
end