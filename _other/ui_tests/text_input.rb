require 'gosu'
Class.new(Gosu::Window) do
    def initialize
        super 1280, 720
        self.caption = "TextInput test"
        @text_input = self.text_input = Gosu::TextInput.new
        @font = Gosu::Font.new(30)
    end
    def draw
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
    end
    def offset_at_text_pos text, pos
        @font.text_width(text[0...pos], 1)
    end
    def needs_cursor?
        true
    end
end.new.show