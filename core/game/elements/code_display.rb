require_relative '../../ui_elements/widgets/scrollable'
require_relative '../../ui_elements/widgets/list'
require_relative '../../ui_elements/widgets/button'
require_relative '../../ui_elements/drawables/image'
require_relative '../../ui_elements/drawables/text'
class CodeDisplay < Scrollable
    def build
        self.background_color = Gosu::Color.rgba(235,235,235,255)
        super
    end
    def vertical?
        true
    end
    def load path_file
        
    end
end