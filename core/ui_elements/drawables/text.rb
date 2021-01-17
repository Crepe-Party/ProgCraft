require_relative 'drawable'
require_relative '../../tools/vector'
class Text < Drawable
    attr_accessor :font, :color, :scale, :center_text, :break_lines
    attr_reader :string
    DEFAULT_FONT_SIZE = 20
    def initialize root, string = "", break_lines: false, font: nil, font_size: DEFAULT_FONT_SIZE, color: Gosu::Color::BLACK, scale: 1, center_text: :middle, overflow: :shown, &constraint
        super(root, &constraint)
        self.string, @color, @scale, @center_text, @break_lines = string, color, scale, center_text, break_lines
        @rendered_text = @string
        @font = font || Gosu::Font.new(font_size, name: "Consolas")
        @overflow_hidden = (overflow == :hidden)
    end
    def draw
        x_pos = @rectangle.x
        y_pos = @rectangle.y + 2 #+2 because idk
        if center_text
            text_width = @font.text_width @string, @scale
            x_pos += ((@rectangle.width - text_width) / 2) unless center_text == :vertical
            y_pos += ((@rectangle.height - @font.height) / 2) unless center_text == :horizontal
        end
        @font.draw_text(@rendered_text, x_pos, y_pos, 0, @scale, @scale, @color)
    end
    def apply_constraints **args
        super **args
        @rendered_text = @break_lines ? text_constrained_to_width(@string) : @string
    end
    def string= new_string
        @string = new_string
        apply_constraints
        new_string
    end
    def offset_at_text_pos text, pos
        self.font.text_width text[0...pos], 1 
    end
    def text_pos_at_offset text, offset
        final_pos = 0
        text.length.downto(0) do |pos|
            break final_pos = pos + 1 if offset > offset_at_text_pos(text, pos)
        end
        final_pos
    end
    def text_height
        @rendered_text.lines.count * @font.height
    end
    #breaks on spaces to 
    def text_constrained_to_width(text)
        lines = text.lines.map{|line| line.split(" ")}
        lines.each_with_index do |words, line_index|
            words.count.downto(1) do |words_count|
                line_words = words[...words_count]
                if(@font.text_width(line_words.join(" ")) <= @rectangle.width)
                    unless(words_count == words.count)
                        lines.insert(line_index + 1, words[words_count...])
                        lines[line_index] = line_words
                    end
                    break
                end
            end
        end
        lines.map{|words| words.join(" ")}.join("\n")
    end
    def autobreaked_string= new_text
        self.string = text_constrained_to_width(new_text)
    end
end