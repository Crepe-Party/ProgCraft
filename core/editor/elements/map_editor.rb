require_relative '../../ui_elements/widgets/game_container'
class MapEditorDisplay < GridGameContainer
    def build
        self.background_color = Gosu::Color::rgba(0,200,0, 255)
        # @sub_elements[:test] = Rectangle.new(@root, Gosu::Color::RED){Rectangle2.new(@rectangle.right - 200, @rectangle.y + 100, 400, 100)}
    end
end