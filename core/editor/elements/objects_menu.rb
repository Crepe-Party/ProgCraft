require_relative '../../ui_elements/widgets/scrollable'
require_relative '../../ui_elements/widgets/button'
class ObjectsMenu < Scrollable
    def build
        self.background_color = Gosu::Color.rgba(100,100,100,255)
        10.times do |ind|
            @sub_elements["test_elem_#{ind}".to_sym] = Button.new(@game, "Testeuh #{ind}"){Rectangle2.new(@scrl_rect.x, @scrl_rect.y + 100*ind, @scrl_rect.width, 100)}
        end
        super
    end
    def vertical?
        true
    end
end