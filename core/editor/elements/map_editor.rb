require_relative '../../ui_elements/widgets/grid_game_container'
class MapEditorDisplay < GridGameContainer
    def build
        super
        self.background_color = Gosu::Color::GREEN
        # self.add_event()
        # @sub_elements[:test] = Rectangle.new(@root, Gosu::Color::RED){Rectangle2.new(@rectangle.right - 200, @rectangle.y + 100, 400, 100)}
    end
    def zoomable?
        false
    end
end