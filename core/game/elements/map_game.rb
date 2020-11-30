require_relative '../../ui_elements/widgets/grid_game_container'
require_relative './whats_arbre'
class MapGameDisplay < GridGameContainer
    WA_MARGIN = 20
    WA_BTN_SIZE = 80
    WA_WIDTH = 400
    def build
        self.background_color = Gosu::Color::rgba(0,200,0, 255)
        @sub_elements[:whats_arbre_button] = Button.new(@root, "Whats\nArbre"){Rectangle2.new(@rectangle.right - WA_BTN_SIZE - WA_MARGIN, @rectangle.bottom - WA_BTN_SIZE - WA_MARGIN, WA_BTN_SIZE, WA_BTN_SIZE)}
        @sub_elements[:whats_arbre] = WhatsArbre.new(@root){@rectangle.relative_to(x: @rectangle.width - WA_WIDTH - WA_MARGIN, y: WA_MARGIN, height: - 3*WA_MARGIN - WA_BTN_SIZE).assign!(width: WA_WIDTH)}
        super
    end
end