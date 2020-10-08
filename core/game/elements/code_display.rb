require_relative '../../ui_elements/widgets/scrollable'
require_relative '../../ui_elements/drawables/text'
require_relative '../../tools/file_manager'
class CodeDisplay < Scrollable
    attr :code
    def build
        self.background_color = Gosu::Color.rgba(235,235,235,255)
        @sub_elements[:code] = Text.new(@game, "Display"){@scrl_rec.assign(height: 20)}
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