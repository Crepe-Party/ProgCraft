require_relative '../../ui_elements/widgets/scrollable'
class ObjectsMenu < Scrollable
    def build
        self.background_color = Gosu::Color.rgba(100,100,100,255)
        super
    end
    def vertical?
        true
    end
end