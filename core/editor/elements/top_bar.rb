require_relative '../../ui_elements/ui_element'
require_relative '../../ui_elements/widgets/button'
class EditorTopBar < UIElement
    def build
        self.background_color = Gosu::Color::GRAY
        @sub_elements[:open_button] = Button.new(@game, "Open"){Rectangle2.new(@rectangle.x + 10, @rectangle.y + 5, 200, 40)}
        @sub_elements[:save_button] = Button.new(@game, "Save"){Rectangle2.new(@rectangle.right - 200 - 10, @rectangle.y + 5, 200, 40)}
        super
    end
end