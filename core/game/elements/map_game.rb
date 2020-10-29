require_relative '../../ui_elements/widgets/game_container'
class MapGameDisplay < GridGameContainer
    def build
        self.background_color = Gosu::Color::rgba(0,200,0, 255)
        @sub_elements[:mapname] = Text.new(@root, "map_sans_titre.json", center_text: false, color: Gosu::Color::BLACK, font: Gosu::Font.new(20 ,name: "Consolas")){@rectangle.relative_to(x: 5, y: 5)}
    end
    def path_file= mapname
        @sub_elements[:mapname].string = mapname.split('/').last
    end
end