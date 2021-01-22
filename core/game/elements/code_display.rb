require_relative '../../ui_elements/widgets/list'
require_relative '../../ui_elements/widgets/scrollable'
require_relative '../../ui_elements/drawables/text'
require_relative '../../tools/file_manager'
require_relative '../../config'
class CodeDisplay < Scrollable
    attr_reader :code
    DEFAULT_PATH_FILE = File.join(Config::MY_CODES_DIR, "sans_titre.rb")
    def build
        @path_file = DEFAULT_PATH_FILE

        self.background_color = Gosu::Color::BLACK
        @sub_elements[:code_lines] = List.new(@root, CodeLine){@scrl_rect}
        @sub_elements[:highlight] =  Rectangle.new(@root, Gosu::Color::rgba(255,255,255,50))
        .constrain{(@sub_elements[:code_lines].list_elements[@line_number || 0]&.rectangle) || Rectangle2.new}
        
        sync
        super
    end
    def vertical?
        true
    end
    def load path_file
        @path_file = path_file
        @mtime = File.mtime @path_file
        self.code = File_manager.read @path_file
    end
    def code= new_code
        @code = new_code
        @sub_elements[:code_lines].data = @code.lines
    end
    def clear_code
        self.code = ""
    end
    def sync
        old_path_file = @path_file
        current_state = :empty
        Thread.new do
            loop do
                if (File.exist? @path_file)
                    current_state = :loaded unless current_state == :loaded
                    if @mtime != (File.mtime @path_file) || old_path_file != @path_file
                        old_path_file = @path_file
                        @root.plan_action do
                            load @path_file
                            @root.load_program @path_file
                            @root.stop
                        end
                    end
                elsif current_state != :empty
                    clear_code
                    root.stop
                    current_state = :empty
                end
                sleep 1
            end
        end
    end
    def highlight line_number
        @line_number = line_number.to_i-1
        apply_constraints
    end
    class CodeLine < UIElement
        include Listable
        LINE_NUMBER_LENGTH = 4
        CODE_FONT = Gosu::Font.new(20 ,name: "Consolas")
        def build
            @sub_elements[:line_number] = Text.new(@root, color: Gosu::Color::AQUA, font: CODE_FONT, center_text: false)
            .constrain{|el| @rectangle.assign(width: el.text_width)}
            @sub_elements[:code_line] = Text.new(@root, color: Gosu::Color::WHITE, font: CODE_FONT, break_lines: true, center_text: false)
            .constrain{num_width = @sub_elements[:line_number].rectangle.width; @rectangle.relative_to(x: num_width, width: -num_width)}
        end
        def update_data new_data
            @sub_elements[:line_number].string = (@index + 1).to_s.rjust(LINE_NUMBER_LENGTH) + " "
            @sub_elements[:code_line].string = new_data
        end
        def list_constraint parent_rect
            parent_rect.assign(y:0, height: @sub_elements[:code_line].text_height)
        end
    end
end