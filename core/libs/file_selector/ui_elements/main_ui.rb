require_relative '../../../ui_elements/widgets/scrollable'
require_relative '../../../ui_elements/ui_element'
require_relative 'path_section'
require_relative '../../../ui_elements/drawables/rectangle'
module FileSelectorUI
    class MainUI < UIElement
        PATH_SECTION_HEIGHT = 50
        def build
            self.background_color = Gosu::Color::rgba 64,64,64,255
            @sub_elements[:path_section] = PathSection.new(@root){@rectangle.assign(height: PATH_SECTION_HEIGHT)}
            @sub_elements[:separator_1] = Rectangle.new(@root){@rectangle.assign(y:PATH_SECTION_HEIGHT, height:2)}
        end
    end
end