require_relative '../../ui_elements/ui_element'
class MapEditorDisplay < UIElement
    def build
        self.background_color = Gosu::Color::BLUE
        @sub_elements[:test] = Rectangle.new(@game, Gosu::Color::RED){Rectangle2.new(@rectangle.right - 200, @rectangle.y + 100, 400, 100)}
    end
end