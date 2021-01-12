require_relative '../../ui_elements/ui_element'
require_relative '../../ui_elements/widgets/list'
class ErrorConsole < Scrollable
    TOP_BAR_HEIGHT = 50
    def build
        self.background_color = Gosu::Color::rgba(64,64,64,255)
        @sub_elements[:top_bar] = ConsoleTopBar.new(@root)
        .constrain{@rectangle.assign(height: TOP_BAR_HEIGHT)}
        
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
            @sub_elements[:title] = Text.new(@root, "Console", color: Gosu::Color::WHITE)
            @sub_elements[:toggle_button] = Button.new(@root, "▲")
            .constrain{@rectangle.assign(x:@rectangle.right - 20, width: 20, height: 20)}
            .on_click{@root.console_open^=true}
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