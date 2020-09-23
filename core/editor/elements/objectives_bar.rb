require_relative '../../ui_elements/widgets/list'
class ObjectivesBar < List
    def build
        self.background_color = Gosu::Color.rgba(50,50,50,255)
        super
    end
    def vertical?
        false
    end
end