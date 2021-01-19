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
        @answer_callbacks = []
        self.background_color = Gosu::Color::rgba(200, 200, 200, 128)
        @sub_elements[:scroll] = MessagesScroll.new(@root){ @rectangle.relative_to(height: -INPUT_SECT_HEIGHT) }

        @sub_elements[:clear_btn] = Button.new(@root, "Clear")
            .constrain{ @rectangle.relative_to(x: 5, y: 5).assign!(width: 150, height: 50) }
            .add_event(:click){ self.clear }

        @sub_elements[:input_section] = Rectangle.new(@root, Gosu::Color::rgba(128, 128, 128, 128))
            .constrain{ @rectangle.relative_to(y: @rectangle.height - INPUT_SECT_HEIGHT).assign!(height: INPUT_SECT_HEIGHT) }

        @sub_elements[:text_input] = TextInput.new(@root, placeholder: "Your message...")
            .constrain{ @sub_elements[:input_section].rectangle.relative_to(x: 5, y: 5, height: -10, width: -SEND_BTN_WIDTH - 15) }
            .add_event(:submit) do |value:, input:|
                next if value.empty?
                self.push_message(value, "Player")
                input.clear
                @answer_callbacks.each{ |al| al.call(value) }
                @answer_callbacks.clear
            end

        @sub_elements[:send_button] = Button.new(@root, ">")
            .constrain{ rc = @sub_elements[:text_input].rectangle; rc.assign(x: rc.right + 5, width: SEND_BTN_WIDTH) }
            .on_click do
                @sub_elements[:text_input].submit
            end
    end
    def push message
        @sub_elements[:scroll][:list].data += [message]
        
        # TODO block auto-scroll  if user is looking at old messages
        if @sub_elements[:scroll][:list].list_elements.last.rectangle.bottom > @rectangle.bottom - INPUT_SECT_HEIGHT - Scrollable::SCROLL_BUTTONS_SIZE
            message_height = @sub_elements[:scroll][:list].list_elements.last.rectangle.height + 20
            @sub_elements[:scroll].scroll_offset -= message_height
        end
    end
    def clear
        @sub_elements[:scroll][:list].data = []
        @sub_elements[:scroll].scroll_offset = 0
    end
    def push_message text, source = "Robert"
        msg = Message.new(text, source)
        self.push msg
        #open
        @parent_element.whats_arbre_open = true
        msg
    end
    #register answer listener
    def on_answer &block
        @answer_callbacks.push(block)
    end
    #sub classes
    class MessagesScroll < Scrollable
        def build
            @sub_elements[:list] = List.new(@root, MessageElement, spacing: 20, start_offset: 20 + 50, parent_element: self){ @scrl_rect }
            super
        end
    end
    class MessageElement < UIElement
        include Listable
        LOCAL_MESSAGE_COLOR = Gosu::Color::rgba(128, 255, 128, 255)
        FOREIGN_MESSAGE_COLOR = Gosu::Color::rgba(128, 128, 255, 255)
        SIDE_OFFSET = 80
        MARGIN = 5
        PADDING = 10
        def build
            self.background_color = LOCAL_MESSAGE_COLOR
            @sub_elements[:title] = Text.new(@root, center_text: false)
            .constrain{ @rectangle.assign(height: 20).relative_to(x: PADDING, y: PADDING, width: -2*PADDING) }
            @sub_elements[:text] = Text.new(@root, center_text: false, break_lines: true)
            .constrain{|el| r=@sub_elements[:title].rectangle; r.assign(y: r.bottom + PADDING, height: el.text_height)}
        end
        def update_data message
            @sub_elements[:title].string = message.source
            @sub_elements[:text].string = message.text
            @is_foreign = (message.source == "Robert")
            self.background_color = (@is_foreign ? FOREIGN_MESSAGE_COLOR : LOCAL_MESSAGE_COLOR)
        end
        def list_constraint parent_rect
            base_rect = parent_rect
                .assign(y:0, height: @sub_elements[:title].rectangle.height + @sub_elements[:text].rectangle.height + 3*PADDING)
                .relative_to!(x: MARGIN, width: -2*MARGIN - SIDE_OFFSET)
            if @is_foreign
                base_rect
            else
                base_rect.relative_to!(x: SIDE_OFFSET)
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