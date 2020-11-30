require_relative '../../ui_elements/widgets/scrollable'
require_relative '../../ui_elements/widgets/list'
require_relative '../../ui_elements/drawables/text'
class WhatsArbre < UIElement
    INPUT_SECT_HEIGHT = 50
    def build
        self.background_color = Gosu::Color::rgba(200,200,200,128)
        @sub_elements[:scroll] = MessagesScroll.new(@root){@rectangle.relative_to(height: -INPUT_SECT_HEIGHT)}
    end
    class MessagesScroll < Scrollable
        def build
            @sub_elements[:list] = List.new(@root, MessageElement, spacing: 20, start_offset: 20, parent_element: self){@scrl_rect}
            @sub_elements[:list].data = [
                Message.new("Bonsoir", "Robert"),
                Message.new("Salut Robert!", "Player"),
                Message.new("Yes!", "Robert"),
            ]
            super
        end
    end
    class MessageElement < UIElement
        include Listable
        LOCAL_MESSAGE_COLOR = Gosu::Color::rgba(128,255,128,255)
        FOREIGN_MESSAGE_COLOR = Gosu::Color::rgba(128,128,255,255)
        def build
            self.background_color = LOCAL_MESSAGE_COLOR
            @sub_elements[:title] = Text.new(@root, center_text: false){@rectangle.assign(height: 20).relative_to(x:5, y:5)}
            @sub_elements[:text] = Text.new(@root, center_text: false){@rectangle.relative_to(x:5, y:30, width: -10, height: -30)}
        end
        def update_data message
            @sub_elements[:title].string = message.source
            @sub_elements[:text].string = message.text
            @is_foreign = (message.source == "Robert")
            self.background_color = (@is_foreign ? FOREIGN_MESSAGE_COLOR : LOCAL_MESSAGE_COLOR)
        end
        def list_constraint parent_rect
            if @is_foreign
                parent_rect.assign(y: 0, height: 100).relative_to!(x:5, width: -60)
            else
                parent_rect.assign(y: 0, height: 100).relative_to!(x:55, width: -60)
            end
        end
    end
    class Message
        attr_accessor :source, :text
        def initialize text, source = "Unknown"
            self.text, self.source = text, source
        end
    end
end