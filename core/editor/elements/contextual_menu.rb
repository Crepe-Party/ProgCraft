require_relative '../../ui_elements/widgets/text_input'
class EditorContextualMenu < UIElement
    INPUT_HEIGHT = 30
    def build
        self.background_color = Gosu::Color.rgba(70,70,70,255)

        #map width
        @sub_elements[:map_width_label] = Text.new(@root, "Map width", center_text: :vertical)
        .constrain{@rectangle.relative_to(x:5, y:5, width: -10).assign!(height:INPUT_HEIGHT)}
        @sub_elements[:map_width_input] = TextInput.new(@root, placeholder: "Enter a width")
        .constrain{@sub_elements[:map_width_label].rectangle.relative_to(y:INPUT_HEIGHT - 5)}
        .add_event(:submit) do |value:, input:|
            val = value.to_i
            @root.level.maps.first.size.x = val if val > 0
            on_map_update
        end
        
        #map height
        @sub_elements[:map_height_label] = Text.new(@root, "Map height", center_text: :vertical)
        .constrain{@sub_elements[:map_width_input].rectangle.relative_to(y: INPUT_HEIGHT + 5)}
        @sub_elements[:map_height_input] = TextInput.new(@root, placeholder: "Enter a height")
        .constrain{@sub_elements[:map_height_label].rectangle.relative_to(y: INPUT_HEIGHT - 5)}
        .add_event(:submit) do |value:, input:|
            val = value.to_i
            @root.level.maps.first.size.y = val if val > 0
            on_map_update
        end
    end
    def on_map_update
        @sub_elements[:map_width_input].value = @root.level.maps.first.size.x
        @sub_elements[:map_height_input].value = @root.level.maps.first.size.y
    end
end