require_relative '../../ui_elements/widgets/scrollable'
require_relative '../../ui_elements/drawables/text'
require_relative '../../tools/file_manager'
class CodeDisplay < Scrollable
    attr :code
    LINE_HEIGHT = 20
    def build
        self.background_color = Gosu::Color.rgba(0,0,0,0)
        super
    end
    def vertical?
        true
    end
    def load path_file
        @code = File_manager.read path_file
        code_lines = @code.split("\n")
        code_lines.each_with_index do |code_line, index|
            self.format_line "#{index}    #{code_line}\n"
        end
        apply_constraints
    end
    def format_line code_line
        words = code_line.split
        words.each do |word|

            puts "#{word}\n"
        end
        # @sub_elements[index.to_s] = Text.new(@root, , center_text: false, color: Gosu::Color::WHITE){@scrl_rect.relative_to(y: index*LINE_HEIGHT)}
    end
end