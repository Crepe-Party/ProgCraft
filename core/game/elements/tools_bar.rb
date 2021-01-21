require_relative '../../ui_elements/ui_element'
require_relative '../../ui_elements/drawables/text'
require_relative '../../ui_elements/widgets/text_input'
class ToolsBar < UIElement    
    BAR_HEIGHT = 50
    INPUTS_HEIGHT = BAR_HEIGHT - 20
    SEPARATION_HEIGHT = 2
    def build
        self.background_color = Gosu::Color::rgba(64,64,64,255)
        @sub_elements[:title] = Text.new(@root, "Speed:", color: Gosu::Color::WHITE, center_text: :vertical)
            .constrain{@rectangle.relative_to(x: 10).assign!(width: 60)}
        @sub_elements[:text_input] = TextInput.new(@root, placeholder: "1",border_width: 2, cursor_width: 2)
            .constrain do
                rect = @sub_elements[:title].rectangle 
                rect.assign(x: rect.right, y: rect.y + 10, height: INPUTS_HEIGHT, width: 50)
            end
            .add_event(:submit) {|value:, input:| @sub_elements[:text_input].text_input_unplugged} # remove focus on submit
            .add_event(:change) do |value:, input:|
                begin
                    p value
                    value = Integer(value)
                    value = -value if value < 0
                rescue => exception
                    next
                end
                @root.robert.speed = value 
            end
        
        @sub_elements[:speed_button] = Button.new(@root, "x1")
            .constrain do
                rect = @sub_elements[:text_input].rectangle
                rect.assign(x: rect.right + 10, width: 30, height: INPUTS_HEIGHT )
            end


        @sub_elements[:tools_bar_separation] = ToolsBarSeparation.new(@root)
        .constrain{ rect = @rectangle; rect.assign(y:rect.bottom - SEPARATION_HEIGHT, height: SEPARATION_HEIGHT)}
    end
end
class ToolsBarSeparation < UIElement    
    def build
        self.background_color = Gosu::Color::rgba(50,50,50,255)
    end
end