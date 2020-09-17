require_relative '../../ui_elements/ui_element'
class ObjectivesBar < UIElement
    def build
        self.background_color = Gosu::Color.rgba(50,50,50,255)
        super
    end
end