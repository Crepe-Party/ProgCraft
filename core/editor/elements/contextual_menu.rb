require_relative '../../ui_elements/widgets/text_input'
class EditorContextualMenu < UIElement
    def build
        self.background_color = Gosu::Color.rgba(70,70,70,255)
        @sub_elements[:test_input] = TextInput.new(@root, placeholder: "Width: 10"){
            @rectangle.relative_to(x: 5, y: 5, width: -10).assign!(height: @sub_elements[:test_input].text_elem.font.height + 10)
        }
        .add_event(:submit) do |value:, input:|
            next if value.empty?
            begin
                val = Integer(value)
                @root.level.maps.first.size.x = val
            rescue => exception
                input.value = @root.level.maps.first.size.x
            end
        end
        @sub_elements[:test_input_2] = TextInput.new(@root, placeholder: "Height: 10"){
            @sub_elements[:test_input].rectangle.assign(y: @sub_elements[:test_input].rectangle.bottom + 10)
        }
        .add_event(:submit) do |value:, input:|
            next if value.empty?
            begin
                val = Integer(value)
                @root.level.maps.first.size.y = val
            rescue => exception
                input.value = @root.level.maps.first.size.y
            end
        end
    end
end