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
            @sub_elements[index.to_s] = Text.new(@root, "#{index}    #{code_line}\n", center_text: false, color: Gosu::Color::WHITE){@scrl_rect.relative_to(y: index*LINE_HEIGHT)}
        end
        apply_constraints
    end
end