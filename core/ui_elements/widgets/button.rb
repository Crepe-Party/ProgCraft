require_relative '../ui_element'
require_relative '../drawables/rectangle'
require_relative '../drawables/text'
class Button < UIElement
    attr_accessor :text
    def initialize game, text="", rectangle=nil, bg_color: Gosu::Color::WHITE, text_color: Gosu::Color::BLACK, &constraint
        @text, @background_color, @text_color = text, bg_color, text_color
        super(game, rectangle, &constraint)
    end
    def build
        self.background_color= @background_color
        @sub_elements[:text] = Text.new(@game, @text, center_text: true){@rectangle}
    end
    def onclick &handler
        @handler = handler
        @game.register_event_listener :click, self, handler
        self
    end
end