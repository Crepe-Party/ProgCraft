require_relative '../ui_element'
require_relative '../drawables/rectangle'
require_relative '../drawables/text'
require_relative '../drawables/image'
require_relative "../../config"
class Button < UIElement
    def initialize root, text = "", bg_color: Gosu::Color::WHITE, bg_color_hover: Gosu::Color.rgba(200, 200, 200, 255), text_color: Gosu::Color::BLACK, text_color_hover: Gosu::Color::BLACK, background_image: nil, background_image_cover: false, &constraint
        @text, @background_color, @background_color_hover, @text_color, @text_color_hover, @background_image, @background_image_cover = text, bg_color, bg_color_hover, text_color, text_color_hover, background_image, background_image_cover
        super root, &constraint 
    end
    def build
        self.background_color= @background_color
        unless @background_image.nil?
            image = Image.new(@root, File.join(Config::ASSETS_DIR,"#{@background_image}"), cover: @background_image_cover){ Rectangle2.new(@rectangle.x + 1, @rectangle.y + 1, @rectangle.width - 2, @rectangle.height - 2) }
            @sub_elements[:background_image] = image
        end
        @sub_elements[:text] = Text.new(@root, @text, center_text: true){ @rectangle }
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
            text_elem.color = @text_color_hover
        end
        add_event(:mouse_leave) do
            background_elem.color = @background_color
            text_elem.color = @text_color
        end
    end
    def on_click &handler
        add_event :click, &handler 
    end
end

