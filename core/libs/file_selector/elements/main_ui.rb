require_relative '../../../ui_elements/ui_element'
require_relative '../../../ui_elements/drawables/rectangle'
require_relative 'path_section'
require_relative 'action_section'
module FileSelectorUI
    class MainUI < UIElement
        PATH_SECTION_HEIGHT = 50
        ACTION_SECTION_HEIGHT = 50
        def build
            self.background_color = Gosu::Color::rgba 64,64,64,255
            @sub_elements[:path_section] = PathSection.new(@root){@rectangle.assign(height: PATH_SECTION_HEIGHT)}
            @sub_elements[:separator_1] = Rectangle.new(@root){@rectangle.assign(y:@sub_elements[:path_section].rectangle.bottom, height:2)}
            @sub_elements[:action_section] = ActionSection.new(@root){@rectangle.assign(y: @sub_elements[:separator_1].rectangle.bottom, height: ACTION_SECTION_HEIGHT)}
        end
    end
end