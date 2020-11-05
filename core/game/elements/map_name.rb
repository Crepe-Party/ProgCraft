require_relative '../../ui_elements/ui_element'
class MapName < UIElement
    def build
        super
        self.background_color = Gosu::Color::rgba(200,200,200,255)
        @sub_elements[:mapname] = Text.new(@root, "map_sans_titre.json", center_text: false, color: Gosu::Color::BLACK, font: Gosu::Font.new(20 ,name: "Consolas")){@rectangle.relative_to(x: 5, y: 5)}
    end
    def path_file= path_file
        @sub_elements[:mapname].string = path_file.split('/').last
    end
end