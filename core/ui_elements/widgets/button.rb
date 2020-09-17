require_relative '../ui_element'
require_relative '../drawables/rectangle'
require_relative '../drawables/text'
class Button < UIElement
    attr_accessor :text
    def initialize game, rectangle=nil, text="", bg_color: Gosu::Color::WHITE, text_color: Gosu::Color::BLACK
        @text, @background_color, @text_color = text, bg_color, text_color
        super game, rectangle
    end
    def build
        self.background_color= @background_color
        @sub_elements[:text] = Text.new @game, nil, @text, center_text: true
    end
    def apply_constraints
        @sub_elements[:text].rectangle = @rectangle
        super
    end
end