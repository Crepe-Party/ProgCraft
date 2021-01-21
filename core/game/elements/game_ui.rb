require_relative '../../ui_elements/ui_element'
require_relative 'top_bar'
require_relative 'map_game'
require_relative 'code_display'
require_relative 'code_menu'
require_relative 'map_name'
require_relative 'error_console'
require_relative 'tools_bar'
require_relative '../../ui_elements/widgets/about_overlay'
class GameUI < UIElement
    attr_reader :console_open
    #dimensions
    TOP_BAR_HEIGHT = 50
    MAPNAME_BAR_HEIGHT = 25
    LEFT_MENU_WIDTH = 250
    RIGHT_MENU_WIDTH = 600
    RIGHT_MENU_WIDTH_REDUCED = 300
    BOTTOM_BAR_HEIGHT = 150
    MAPS_MENU_HEIGHT = 250
    CONSOLE_HEIGHT = 300
    def build
        @console_open = false
        #menus
        @sub_elements[:top_bar] = GameTopBar.new(@root){ Rectangle2.new(@rectangle.x, @rectangle.y, @rectangle.right - responsive_right_menu_width, TOP_BAR_HEIGHT) }
        #game
        @sub_elements[:map_name] = MapName.new(@root){ Rectangle2.new(@rectangle.x, @rectangle.y + TOP_BAR_HEIGHT, @rectangle.width - responsive_right_menu_width, MAPNAME_BAR_HEIGHT) }
        @sub_elements[:map_game] = MapGameDisplay.new(@root){ Rectangle2.new(@rectangle.x, @rectangle.y + TOP_BAR_HEIGHT + MAPNAME_BAR_HEIGHT, @rectangle.width - responsive_right_menu_width, @rectangle.height - TOP_BAR_HEIGHT - MAPNAME_BAR_HEIGHT) }
        #code
        @sub_elements[:code_menu] = CodeMenu.new(@root){ Rectangle2.new(@rectangle.right - responsive_right_menu_width, @rectangle.y , responsive_right_menu_width, TOP_BAR_HEIGHT) }
        @sub_elements[:code_display] = CodeDisplay.new(@root)
        .constrain{ Rectangle2.new(@rectangle.right - responsive_right_menu_width, TOP_BAR_HEIGHT, responsive_right_menu_width, @rectangle.height - TOP_BAR_HEIGHT - ToolsBar::BAR_HEIGHT - ErrorConsole::TOP_BAR_HEIGHT * (1-(@console_open_progress || 0)) - CONSOLE_HEIGHT * (@console_open_progress || 0)) }
        @sub_elements[:tools_bar] = ToolsBar.new(@root)
        .constrain{ rect = @sub_elements[:code_display].rectangle; rect.assign(y:rect.bottom, height: ToolsBar::BAR_HEIGHT)}
        @sub_elements[:tools_bar_separation] = ToolsBarSeparation.new(@root)
        .constrain{ rect = @sub_elements[:tools_bar].rectangle; rect.assign(y:rect.bottom, height: 2)}
        @sub_elements[:console] = ErrorConsole.new(@root)
        .constrain{ rect = @sub_elements[:tools_bar_separation].rectangle; rect.assign(y:rect.bottom, height: CONSOLE_HEIGHT)}
        #legal stuff
        @sub_elements[:about_stuff] = AboutOverlay.new(@root){@rectangle}

        #debug heights
        # 0.upto(10) do |ind|
        #     @sub_elements["debug_line_#{ind}"] = Rectangle.new(@root, Gosu::Color::RED){@rectangle.assign(y:ind*100, height:5)}
        #     @sub_elements["debug_line_text_#{ind}"] = Text.new(@root, ind*100, color:Gosu::Color::RED, center_text: false)
        #     .constrain{@rectangle.assign(y:ind*100 - 20, height:5)}
        # end
    end
    def smaller_screen?
        @root.width < 1200
    end
    def responsive_right_menu_width
        smaller_screen? ? RIGHT_MENU_WIDTH_REDUCED : RIGHT_MENU_WIDTH
    end
    def console_open= is_open
        return if is_open == @console_open
        @console_open = is_open
        @sub_elements[:console].is_open = is_open
        #animate
        @current_console_animation.cancel if @current_console_animation
        @current_console_animation = @root.animate(0.5, from: (@console_open_progress || 0), to: (is_open)?1:0, timing_function: :ease) do
            |progress|
            @console_open_progress = progress
            apply_constraints
        end
    end
end