require_relative '../../ui_elements/widgets/scrollable'
class ObjectivesBar < Scrollable
    def build
        self.background_color = Gosu::Color.rgba(50,50,50,255)
        @sub_elements[:test] = Button.new(@game, "Holé"){Rectangle2.new(@scrl_rect.x, @scrl_rect.y, @scrl_rect.height, 200)}
        super
    end
    def vertical?
        false
    end
end