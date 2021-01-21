require_relative '../../ui_elements/ui_element'
require_relative '../../ui_elements/widgets/list'
class ToolsBar < UIElement    
    BAR_HEIGHT = 50
    def build
        self.background_color = Gosu::Color::rgba(64,64,64,255)
        @sub_elements[:title] = Text.new(@root, "Console", color: Gosu::Color::WHITE, center_text: :vertical)
        .constrain{@rectangle.relative_to(x: 10, width: -30)}
    end
end