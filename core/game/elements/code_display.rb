require_relative '../../ui_elements/widgets/scrollable'
require_relative '../../ui_elements/drawables/text'
require_relative '../../tools/file_manager'
class CodeDisplay < Scrollable
    attr :code
    LINE_NUMBER_WIDTH = 40
    def build
        self.background_color = Gosu::Color.rgba(235,235,235,255)
        lines_number = ""
        1.upto 50 do |line_number|
            lines_number+="#{line_number}\n"
        end
        @sub_elements[:line_number] = Text.new(@root, lines_number, center_text: false){@scrl_rect.assign(width: LINE_NUMBER_WIDTH)}
        @sub_elements[:code] = Text.new(@root, "", center_text: false){@scrl_rect.relative_to(x: LINE_NUMBER_WIDTH, width: -LINE_NUMBER_WIDTH)}
        super
    end
    def vertical?
        true
    end
    def load path_file
        @code = File_manager.read path_file
        @sub_elements[:code].string = @code
    end
end