require_relative '../../ui_elements/widgets/text_input'
class EditorContextualMenu < UIElement
    def build
        self.background_color = Gosu::Color.rgba(70,70,70,255)
        @sub_elements[:test_input] = TextInput.new(@root, placeholder: "Ex: bonjour"){
            @rectangle.relative_to(x: 5, y: 5, width: -10).assign!(height: @sub_elements[:test_input].text_elem.font.height + 10)
        }
        @sub_elements[:test_input_2] = TextInput.new(@root, placeholder: "Ex: au revoir"){
            @sub_elements[:test_input].rectangle.assign(y: @sub_elements[:test_input].rectangle.bottom + 10)
        }
    end
end