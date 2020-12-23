require_relative '../../ui_elements/ui_element'
require_relative 'top_bar'
require_relative 'map_game'
require_relative 'code_display'
require_relative 'code_menu'
require_relative 'map_name'
class GameUI < UIElement
    #dimensions
    TOP_BAR_HEIGHT = 50
    MAPNAME_BAR_HEIGHT = 25
    LEFT_MENU_WIDTH = 250
    RIGHT_MENU_WIDTH = 600
    BOTTOM_BAR_HEIGHT = 150
    MAPS_MENU_HEIGHT = 250
    def build
        #menus
        @sub_elements[:top_bar] = GameTopBar.new(@root){ Rectangle2.new(@rectangle.x, @rectangle.y, @rectangle.right - RIGHT_MENU_WIDTH, TOP_BAR_HEIGHT) }
        #game
        @sub_elements[:map_name] = MapName.new(@root){ Rectangle2.new(@rectangle.x, @rectangle.y + TOP_BAR_HEIGHT, @rectangle.width - RIGHT_MENU_WIDTH, MAPNAME_BAR_HEIGHT) }
        @sub_elements[:map_game] = MapGameDisplay.new(@root){ Rectangle2.new(@rectangle.x, @rectangle.y + TOP_BAR_HEIGHT + MAPNAME_BAR_HEIGHT, @rectangle.width - RIGHT_MENU_WIDTH, @rectangle.height - TOP_BAR_HEIGHT - MAPNAME_BAR_HEIGHT) }
        #code
        @sub_elements[:code_menu] = CodeMenu.new(@root){ Rectangle2.new(@rectangle.right - RIGHT_MENU_WIDTH, @rectangle.y , RIGHT_MENU_WIDTH, TOP_BAR_HEIGHT) }
        @sub_elements[:code_display] = CodeDisplay.new(@root){ Rectangle2.new(@rectangle.right - RIGHT_MENU_WIDTH, TOP_BAR_HEIGHT, RIGHT_MENU_WIDTH, @rectangle.height) }
    end
    def update dt
        super dt
    end
end