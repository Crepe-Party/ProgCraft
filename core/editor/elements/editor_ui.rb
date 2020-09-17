require_relative '../../ui_elements/ui_element'
require_relative 'top_bar'
require_relative 'maps_menu'
require_relative 'contextual_menu'
require_relative 'objectives_bar'
require_relative 'objects_menu'
class EditorUI < UIElement
    #dimensions
    TOP_BAR_HEIGHT = 50
    LEFT_MENU_WIDTH = 250
    RIGHT_MENU_WIDTH = 150
    BOTTOM_BAR_HEIGHT = 150
    MAPS_MENU_HEIGHT = 250
    def build
        super
        @sub_elements[:top_bar] = EditorTopBar.new @game
        @sub_elements[:maps_menu] = MapsMenu.new @game
        @sub_elements[:contextual_menu] = EditorContextualMenu.new @game
        @sub_elements[:objectives_bar] = ObjectivesBar.new @game
        @sub_elements[:objects_menu] = ObjectsMenu.new @game
        #fps
        @sub_elements[:fps_text] = Text.new(@game, Rectangle2.new(nil, nil, 60, 50), "...fps", color: Gosu::Color::WHITE, center_text: false)
    end
    def update dt
        super dt
        @sub_elements[:fps_text].string = "#{(1/dt).floor} fps"
    end
    def apply_constraints
        @sub_elements[:top_bar].rectangle = Rectangle2.new(@rectangle.x + LEFT_MENU_WIDTH, @rectangle.y, @rectangle.right - RIGHT_MENU_WIDTH - LEFT_MENU_WIDTH, TOP_BAR_HEIGHT)
        @sub_elements[:maps_menu].rectangle = Rectangle2.new(@rectangle.x, @rectangle.y, LEFT_MENU_WIDTH, MAPS_MENU_HEIGHT)
        @sub_elements[:contextual_menu].rectangle = Rectangle2.new(@rectangle.x, @rectangle.y + MAPS_MENU_HEIGHT, LEFT_MENU_WIDTH, @rectangle.height - MAPS_MENU_HEIGHT)
        @sub_elements[:objectives_bar].rectangle = Rectangle2.new(@rectangle.x + LEFT_MENU_WIDTH, @rectangle.bottom - BOTTOM_BAR_HEIGHT, @rectangle.width - LEFT_MENU_WIDTH, BOTTOM_BAR_HEIGHT)
        @sub_elements[:objects_menu].rectangle = Rectangle2.new(@rectangle.right - RIGHT_MENU_WIDTH, @rectangle.y, RIGHT_MENU_WIDTH, @rectangle.height - BOTTOM_BAR_HEIGHT)
        #fps
        @sub_elements[:fps_text].rectangle.x = @rectangle.right - 60
        @sub_elements[:fps_text].rectangle.y = @rectangle.height - 50
        super
    end
end