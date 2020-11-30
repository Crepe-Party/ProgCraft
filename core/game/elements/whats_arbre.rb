require_relative '../../ui_elements/widgets/scrollable'
require_relative '../../ui_elements/widgets/list'
class WhatsArbre < UIElement
    INPUT_SECT_HEIGHT = 50
    def build
        self.background_color = Gosu::Color::rgba(255,255,255,200)
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
            self.background_color = FOREIGN_MESSAGE_COLOR
        end
        def update_data data
            puts "data :) #{data}"
        end
        def list_constraint parent_rect
            parent_rect.assign(y: 0, height: 100)
        end
    end
    class Message
        attr_accessor :source, :text
        def initialize text, source = "Unknown"
            self.text, self.source = text, source
        end
    end
end