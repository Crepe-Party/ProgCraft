require_relative '../../ui_elements/ui_element'
require_relative '../../ui_elements/widgets/list'
class ErrorConsole < Scrollable
    TOP_BAR_HEIGHT = 50
    def build
        @detailed_error_sessions = []
        self.background_color = Gosu::Color::rgba(32,32,32,255)
        
        @sub_elements[:errors_list] = List.new(@root, ConsoleEntry)
        .constrain{@scrl_rect.relative_to(y:TOP_BAR_HEIGHT)}
        
        @sub_elements[:top_bar] = ConsoleTopBar.new(@root)
        .constrain{@rectangle.assign(height: TOP_BAR_HEIGHT)}
        .add_event(:click){@root.main_ui.console_open^=true}

        @sub_elements[:clear_btn] = Button.new(@root, background_image: 'icons/trashbin.png', background_image_cover: true)
        .constrain{Rectangle2.new(@rectangle.right - 45, @rectangle.bottom - 45, 40,40)}
        .on_click{self.clear}

        @no_scroll_elements += [:top_bar, :clear_btn]

        def is_open= is_open
            @sub_elements[:top_bar][:toggle_button].text = is_open ? "▼" : "▲"
        end

        def scroll_buttons?
            false
        end
        super
    end
    def clear
        @detailed_error_sessions.clear
        self.scroll_offset = 0
        @sub_elements[:errors_list].data = []
    end
    def push_error(error)
        @root.main_ui.console_open = true
        pretty_backtrace = error.backtrace.first.sub(/^\(eval\):/, "#{@root.last_loaded_program ? File.basename(@root.last_loaded_program) : 'eval'}:\1") #prettier location
        time = Time.now
        should_autoscroll = (self.scroll_size - self.scroll_offset) < 10
        @sub_elements[:errors_list].data += [{
            time: time,
            error: "#{pretty_backtrace} (#{error.class.to_s}) => ..."
        }]
        self.scroll_to(:end) if should_autoscroll
        #slow error handling
        data_index = @sub_elements[:errors_list].data.length - 1
        error_session_id = rand
        @detailed_error_sessions.push(error_session_id)
        Thread.new do
            #simple message
            error_string = error.to_s
            #exit thread if reset has occured
            next unless @detailed_error_sessions.include?(error_session_id)
            @detailed_error_sessions -= [error_session_id]
            new_data = @sub_elements[:errors_list].data.clone
            new_data[data_index] = new_data[data_index].clone
            new_data[data_index][:error] = "#{pretty_backtrace} (#{error.class.to_s}) => #{error_string}"
            @root.plan_action do 
                @sub_elements[:errors_list].data = new_data 
                self.scroll_to(:end) if should_autoscroll
            end
        end
    end
    #sub classes
    class ConsoleTopBar < UIElement
        def build
            self.background_color = Gosu::Color::rgba(64,64,64,255)
            @sub_elements[:title] = Text.new(@root, "Console", color: Gosu::Color::WHITE, center_text: :vertical)
            .constrain{@rectangle.relative_to(x: 10, width: -30)}
            @sub_elements[:toggle_button] = Button.new(@root, "▲", bg_color: Gosu::Color::rgba(255,255,255,64))
            .constrain{@rectangle.assign(x:@rectangle.right - 35, width: 35)}
        end
    end
    class ConsoleEntry < UIElement
        include Listable
        TIME_WIDTH = 70
        def build
            @sub_elements[:time] = Text.new(@root, break_lines: true, center_text: false, color: Gosu::Color::WHITE){@rectangle.assign(width: TIME_WIDTH)}
            @sub_elements[:error] = Text.new(@root, break_lines: true, center_text: false, color: Gosu::Color::rgba(255,64,64,255)){@rectangle.relative_to(x:TIME_WIDTH + 5, width: -TIME_WIDTH - 5)}
        end
        def update_data new_data
            @sub_elements[:time].string = "#{new_data[:time].hour}:#{new_data[:time].min.to_s.rjust(2, '0')}:#{new_data[:time].sec.to_s.rjust(2, '0')}"
            @sub_elements[:error].string = new_data[:error]
        end
        def list_constraint parent_rect
            parent_rect.assign(y:0, height: @sub_elements[:error].text_height)
        end
    end
end