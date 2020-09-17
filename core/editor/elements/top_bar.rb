require_relative '../../ui_elements/ui_element'
require_relative '../../ui_elements/widgets/button'
class EditorTopBar < UIElement
    def build
        self.background_color = Gosu::Color::GRAY
        @sub_elements[:open_button] = Button.new(@game, Rectangle2.new(nil, @rectangle.y + 5, 200, 40), "Open")
        @sub_elements[:save_button] = Button.new(@game, Rectangle2.new(nil, @rectangle.y + 5, 200, 40), "Save")
    end
    def apply_constraints
        @sub_elements[:open_button].rectangle.x = @rectangle.x + 10
        @sub_elements[:save_button].rectangle.x = @rectangle.right - 200 - 10
        super
    end
end