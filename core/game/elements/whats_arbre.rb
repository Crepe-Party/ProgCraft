require_relative '../../ui_elements/widgets/list'
class WhatsArbre < UIElement
     def build
        self.background_color = Gosu::Color::rgba(255,255,255,200)
        @sub_elements[:list] = List.new(@root, Message, spacing: 20, start_offset: 20, parent_element: self)
     end
     class Message
        include Listable
     end
end