require_relative '../../ui_elements/ui_element'
require_relative 'top_bar'
require_relative 'contextual_menu'
require_relative 'map_game'
class GameUI < UIElement
    #dimensions
    TOP_BAR_HEIGHT = 50
    BOTTOM_BAR_HEIGHT = 150
    def build
        #menus
        @sub_elements[:top_bar] = GameTopBar.new(@game){Rectangle2.new(@rectangle.x, @rectangle.y, @rectangle.right, TOP_BAR_HEIGHT)}
        #game
        @sub_elements[:map_game] = MapGameDisplay.new(@game){Rectangle2.new(@rectangle.x, @rectangle.y + TOP_BAR_HEIGHT, @rectangle.width, @rectangle.height - TOP_BAR_HEIGHT - BOTTOM_BAR_HEIGHT)}
        #fps
        @sub_elements[:fps_text] = Text.new(@game, "...fps", color: Gosu::Color::WHITE, center_text: false){Rectangle2.new(@rectangle.right - 60, @rectangle.height - 50, 60, 50)}
    end
    def update dt
        super dt
        @sub_elements[:fps_text].string = "#{(1/dt).floor} fps"
    end
end