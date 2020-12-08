require_relative '../../ui_elements/widgets/scrollable'
require_relative '../../ui_elements/widgets/list'
require_relative '../../ui_elements/widgets/button'
require_relative '../../ui_elements/drawables/text'
require_relative '../../ui_elements/drawables/rectangle'
require_relative '../../ui_elements/widgets/text_input'
class WhatsArbre < UIElement
    INPUT_SECT_HEIGHT = 50
    SEND_BTN_WIDTH = 50
    def build
        self.background_color = Gosu::Color::rgba(200,200,200,128)
        @sub_elements[:scroll] = MessagesScroll.new(@root){@rectangle.relative_to(height: -INPUT_SECT_HEIGHT)}

        @sub_elements[:clear_btn] = Button.new(@root, "Clear")
            .constrain{@rectangle.relative_to(x: 5, y: 5).assign!(width: 150, height: 50)}
            .add_event(:click){self.clear}

        @sub_elements[:rand_btn] = Button.new(@root, "Random")
            .constrain{rc = @sub_elements[:clear_btn].rectangle; rc.assign(x: rc.right + 5)}
            .add_event(:click){self.push(WhatsArbre::Message.new("Salut", ["Robert", "You"].sample))}

        @sub_elements[:input_section] = Rectangle.new(@root, Gosu::Color::rgba(128,128,128,128))
            .constrain{@rectangle.relative_to(y: @rectangle.height - INPUT_SECT_HEIGHT).assign!(height: INPUT_SECT_HEIGHT)}

        @sub_elements[:text_input] = TextInput.new(@root, placeholder: "Your message...")
            .constrain{@sub_elements[:input_section].rectangle.relative_to(x: 5, y: 5, height: -10, width: -SEND_BTN_WIDTH - 15)}

        @sub_elements[:send_button] = Button.new(@root, ">")
            .constrain{rc = @sub_elements[:text_input].rectangle; rc.assign(x: rc.right + 5, width: SEND_BTN_WIDTH)}
            .on_click do
                val = @sub_elements[:text_input].value
                puts val
                self.push(Message.new(val, "Player"));
                # @sub_elements[:text_input].value = value
            end

        self.push Message.new("Bonsoir", "Robert")
        self.push Message.new("Salut Robert!", "Player")
        self.push Message.new("Yes!", "Robert")
    end
    def push message
        @sub_elements[:scroll][:list].data += [message]
    end
    def clear
        @sub_elements[:scroll][:list].data = []
    end
    #sub classes
    class MessagesScroll < Scrollable
        def build
            @sub_elements[:list] = List.new(@root, MessageElement, spacing: 20, start_offset: 20 + 50, parent_element: self){@scrl_rect}
            super
        end
    end
    class MessageElement < UIElement
        include Listable
        LOCAL_MESSAGE_COLOR = Gosu::Color::rgba(128,255,128,255)
        FOREIGN_MESSAGE_COLOR = Gosu::Color::rgba(128,128,255,255)
        SIDE_OFFSET = 80
        MARGIN = 5
        PADDING = 10
        def build
            self.background_color = LOCAL_MESSAGE_COLOR
            @sub_elements[:title] = Text.new(@root, center_text: false){@rectangle.assign(height: 20).relative_to(x:PADDING, y:PADDING)}
            @sub_elements[:text] = Text.new(@root, center_text: false){@rectangle.relative_to(x:PADDING, y:20 + 2*PADDING, width: -2*PADDING, height: -20-2*PADDING)}
        end
        def update_data message
            @sub_elements[:title].string = message.source
            @sub_elements[:text].string = message.text
            @is_foreign = (message.source == "Robert")
            self.background_color = (@is_foreign ? FOREIGN_MESSAGE_COLOR : LOCAL_MESSAGE_COLOR)
        end
        def list_constraint parent_rect
            if @is_foreign
                parent_rect.assign(y: 0, height: 100).relative_to!(x:MARGIN, width: -SIDE_OFFSET - 2*MARGIN)
            else
                parent_rect.assign(y: 0, height: 100).relative_to!(x:SIDE_OFFSET + MARGIN, width: -SIDE_OFFSET - 2*MARGIN)
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