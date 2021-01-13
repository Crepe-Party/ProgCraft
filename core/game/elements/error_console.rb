require_relative '../../ui_elements/ui_element'
require_relative '../../ui_elements/widgets/list'
class ErrorConsole < Scrollable
    TOP_BAR_HEIGHT = 50
    def build
        self.background_color = Gosu::Color::rgba(64,64,64,255)
        @sub_elements[:top_bar] = ConsoleTopBar.new(@root)
        .constrain{@rectangle.assign(height: TOP_BAR_HEIGHT)}
        .add_event(:click){@root.main_ui.console_open^=true}
        
        @sub_elements[:errors_list] = List.new(@root, ConsoleEntry)
        .constrain{@scrl_rect.relative_to(y:TOP_BAR_HEIGHT)}
        @sub_elements[:errors_list].data = [
            {time: Time.now, error: "wow here boi"},
            {time: Time.now, error: "pas ouf"},
            {time: Time.now, error: "ok le gaming"},
            {time: Time.now, error: "nop"},
        ]

        def is_open= is_open
            @sub_elements[:top_bar][:toggle_button].text = is_open ? "▼" : "▲"
        end

        def scroll_buttons?
            false
        end
        super
    end
    #sub classes
    class ConsoleTopBar < UIElement
        def build
            self.background_color = Gosu::Color::rgba(128,128,128,255)
            @sub_elements[:title] = Text.new(@root, "Console", color: Gosu::Color::WHITE, center_text: :vertical)
            .constrain{@rectangle.relative_to(x: 10, width: -30)}
            @sub_elements[:toggle_button] = Button.new(@root, "▲", bg_color: Gosu::Color::rgba(255,255,255,64))
            .constrain{@rectangle.assign(x:@rectangle.right - 35, width: 35)}
        end
    end
    class ConsoleEntry < UIElement
        include Listable
        def build
            @sub_elements[:time] = Text.new(@root){@rectangle.assign(width: 50)}
            @sub_elements[:error] = Text.new(@root){@rectangle.relative_to(x:55, width: -55)}
        end
        def update_data new_data
            @sub_elements[:time].string = new_data[:time].to_s
            @sub_elements[:error].string = new_data[:error].to_s
        end
        def list_constraint parent_rect
            parent_rect.assign(x:0, y:0)
        end
    end
end