require_relative '../ui_element'
require_relative '../drawables/rectangle'
require_relative '../drawables/text'
class Button < UIElement
    attr_accessor :text
    def initialize game, text="", rectangle=nil, bg_color: Gosu::Color::WHITE, bg_color_hover: Gosu::Color.rgba(200, 200, 200, 255), text_color: Gosu::Color::BLACK, &constraint
        @text, @background_color, @background_color_hover, @text_color = text, bg_color, bg_color_hover, text_color
        super(game, rectangle, &constraint)
    end
    def build
        self.background_color= @background_color
        @sub_elements[:text] = Text.new(@game, @text, center_text: true){@rectangle}
        setup_mouse_hover
    end
    def setup_mouse_hover        
        add_event(:mouse_enter) do
            background_elem.color = @background_color_hover
        end
        add_event(:mouse_leave) do
            background_elem.color = @background_color
        end
    end
end

