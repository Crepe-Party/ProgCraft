require_relative '../../ui_elements/ui_element'
class ObjectsMenu < UIElement
    def build
        self.background_color = Gosu::Color.rgba(100,100,100,255)
        super
    end
end