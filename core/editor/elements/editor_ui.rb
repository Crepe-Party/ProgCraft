require_relative '../../ui_elements/ui_element'
require_relative 'top_bar'
# require_relative 'maps_menu'
require_relative 'contextual_menu'
# require_relative 'objectives_bar'
require_relative '../../ui_elements/widgets/about_overlay'
require_relative 'objects_menu'
require_relative 'map_editor'

class EditorUI < UIElement
    #dimensions
    TOP_BAR_HEIGHT = 50
    LEFT_MENU_WIDTH = 250
    RIGHT_MENU_WIDTH = 150
    BOTTOM_BAR_HEIGHT = 0
    MAPS_MENU_HEIGHT = 0

    def build
        #menus
        @sub_elements[:top_bar] = EditorTopBar.new(@root) { @rectangle.relative_to(x: LEFT_MENU_WIDTH, width: -LEFT_MENU_WIDTH - RIGHT_MENU_WIDTH).assign!(height: TOP_BAR_HEIGHT) }
        # @sub_elements[:maps_menu] = MapsMenu.new(@root){Rectangle2.new(@rectangle.x, @rectangle.y, LEFT_MENU_WIDTH, MAPS_MENU_HEIGHT)}
        @sub_elements[:contextual_menu] = EditorContextualMenu.new(@root) { @rectangle.relative_to(y: MAPS_MENU_HEIGHT, height: -MAPS_MENU_HEIGHT).assign!(width: LEFT_MENU_WIDTH) }
        @sub_elements[:objects_menu] = ObjectsMenu.new(@root) { @rectangle.assign(x: @rectangle.right - RIGHT_MENU_WIDTH, width: RIGHT_MENU_WIDTH).relative_to!(height: -BOTTOM_BAR_HEIGHT) }
        # @sub_elements[:objectives_bar] = ObjectivesBar.new(@root){Rectangle2.new(@rectangle.x + LEFT_MENU_WIDTH, @rectangle.bottom - BOTTOM_BAR_HEIGHT, @rectangle.width - LEFT_MENU_WIDTH, BOTTOM_BAR_HEIGHT)}
        #game
        @sub_elements[:map_editor] = MapEditorDisplay.new(@root) { @rectangle.relative_to(x: LEFT_MENU_WIDTH, y: TOP_BAR_HEIGHT, width: -LEFT_MENU_WIDTH - RIGHT_MENU_WIDTH, height: -TOP_BAR_HEIGHT - BOTTOM_BAR_HEIGHT) }
        #legal stuff
        @sub_elements[:about_stuff] = AboutOverlay.new(@root){@rectangle}
        #fps
        # @sub_elements[:fps_text] = Text.new(@root, "... ups", color: Gosu::Color::WHITE, center_text: false){Rectangle2.new(@rectangle.right - 60, @rectangle.height - 50, 60, 50)}
    end

    def update(*args)
        super *args
        # @sub_elements[:fps_text].string = "#{(1/dt).floor} ups" if dt > 0
    end
end