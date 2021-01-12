require_relative '../../ui_elements/ui_element'
require_relative 'top_bar'
require_relative 'map_game'
require_relative 'code_display'
require_relative 'code_menu'
require_relative 'map_name'
require_relative 'error_console'
require_relative '../../ui_elements/widgets/about_overlay'
class GameUI < UIElement
    attr_reader :console_open
    #dimensions
    TOP_BAR_HEIGHT = 50
    MAPNAME_BAR_HEIGHT = 25
    LEFT_MENU_WIDTH = 250
    RIGHT_MENU_WIDTH = 600
    BOTTOM_BAR_HEIGHT = 150
    MAPS_MENU_HEIGHT = 250
    CONSOLE_HEIGHT = 300
    def build
        @console_open = false

        #menus
        @sub_elements[:top_bar] = GameTopBar.new(@root){ Rectangle2.new(@rectangle.x, @rectangle.y, @rectangle.right - RIGHT_MENU_WIDTH, TOP_BAR_HEIGHT) }
        #game
        @sub_elements[:map_name] = MapName.new(@root){ Rectangle2.new(@rectangle.x, @rectangle.y + TOP_BAR_HEIGHT, @rectangle.width - RIGHT_MENU_WIDTH, MAPNAME_BAR_HEIGHT) }
        @sub_elements[:map_game] = MapGameDisplay.new(@root){ Rectangle2.new(@rectangle.x, @rectangle.y + TOP_BAR_HEIGHT + MAPNAME_BAR_HEIGHT, @rectangle.width - RIGHT_MENU_WIDTH, @rectangle.height - TOP_BAR_HEIGHT - MAPNAME_BAR_HEIGHT) }
        #code
        @sub_elements[:code_menu] = CodeMenu.new(@root){ Rectangle2.new(@rectangle.right - RIGHT_MENU_WIDTH, @rectangle.y , RIGHT_MENU_WIDTH, TOP_BAR_HEIGHT) }
        @sub_elements[:code_display] = CodeDisplay.new(@root)
        .constrain{ Rectangle2.new(@rectangle.right - RIGHT_MENU_WIDTH, TOP_BAR_HEIGHT, RIGHT_MENU_WIDTH, @rectangle.height - TOP_BAR_HEIGHT - ErrorConsole::TOP_BAR_HEIGHT - CONSOLE_HEIGHT * (@console_pos_progress || 0)) }
        @sub_elements[:console] = ErrorConsole.new(@root)
        .constrain{ rect = @sub_elements[:code_display].rectangle; rect.assign(y:rect.bottom, height: CONSOLE_HEIGHT)}
        #legal stuff
        @sub_elements[:about_stuff] = AboutOverlay.new(@root){@rectangle}
    end
    def console_open= is_open
        @sub_elements[:console].is_open = is_open
    end
end