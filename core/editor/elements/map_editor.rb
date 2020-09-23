require_relative '../../ui_elements/widgets/game_container'
class MapEditorDisplay < GridGameContainer
    def build
        self.background_color = Gosu::Color::GREEN
        @sub_elements[:test] = Rectangle.new(@game, Gosu::Color::RED){Rectangle2.new(@rectangle.right - 200, @rectangle.y + 100, 400, 100)}
    end
end