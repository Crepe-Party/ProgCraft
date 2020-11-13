require_relative '../../ui_elements/widgets/scrollable'
require_relative '../../ui_elements/drawables/text'
require_relative '../../tools/file_manager'
class CodeDisplay < Scrollable
    attr :code
    LINE_HEIGHT = 20
    def build
        self.background_color = Gosu::Color.rgba(0,0,0,255)
        @code_lines_text_keys = []
        sync
        super
    end
    def vertical?
        true
    end
    def load path_file
        @path_file = path_file
        @mtime = File.mtime @path_file
        @sub_elements.reject!{|key,val|@code_lines_text_keys.include? key}
        @code_lines_text_keys.clear
        @code = File_manager.read @path_file
        code_lines = @code.split("\n")
        code_lines.each_with_index do |code_line, index|
            element = Text.new(@root, "#{index.to_s.rjust(4)}  #{code_line}\n", center_text: false, color: Gosu::Color::WHITE, font: Gosu::Font.new(20 ,name: "Consolas")){@scrl_rect.relative_to(y: index*LINE_HEIGHT+5)}
            key = index.to_s
            @sub_elements[key] = element
            @code_lines_text_keys << key
        end
        apply_constraints
    end
    def sync
        Thread.new{
            loop do
                if @mtime && @path_file
                    if @mtime != (File.mtime @path_file)
                        mtime = File.mtime @path_file
                        load @path_file
                    end
                end
                sleep 1
            end
        }
    end 
end