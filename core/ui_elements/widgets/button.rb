require_relative '../ui_element'
require_relative '../drawables/rectangle'
require_relative '../drawables/text'
class Button < UIElement
    def initialize root, text="", bg_color: Gosu::Color::WHITE, bg_color_hover: Gosu::Color.rgba(200, 200, 200, 255), text_color: Gosu::Color::BLACK, &constraint
        @text, @background_color, @background_color_hover, @text_color = text, bg_color, bg_color_hover, text_color
        super(root, &constraint)
    end
    def build
        self.background_color= @background_color
        @sub_elements[:text] = Text.new(@root, @text, center_text: true){@rectangle}
        setup_mouse_hover
    end
    def text= string
        @sub_elements[:text].string = string
    end
    def text
        @sub_elements[:text].string
    end
    def text_elem
        @sub_elements[:text]
    end
    def setup_mouse_hover        
        add_event(:mouse_enter) do
            background_elem.color = @background_color_hover
        end
        add_event(:mouse_leave) do
            background_elem.color = @background_color
        end
    end
    def on_click &handler
        add_event(:mouse_down, options = {button: Gosu::MS_LEFT}, &handler)
    end
end

