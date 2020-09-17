require_relative '../../ui_elements/ui_element'
require_relative 'top_bar'
class EditorUI < UIElement
    def build
        super
        @sub_elements[:top_bar] = 
    end
end