require_relative '../../ui_elements/ui_element'
require_relative '../../ui_elements/drawables/text'
require_relative '../../ui_elements/widgets/button'
require_relative '../../config'
class CodeMenu < UIElement
    attr_reader :path_file
    BUTTON_WIDTH = 100
    def build
        self.background_color = Gosu::Color.rgba(200, 200, 200, 255)
        @path_file = File.join(Config::MY_CODES_DIR, "sans_titre.rb")
        @sub_elements[:filename] = Text.new(@root, "sans_titre.rb", center_text: false, color: Gosu::Color::BLACK, font: Gosu::Font.new(20 ,name: "Consolas")){ @rectangle.relative_to(x: 5 ,y: @rectangle.y + @rectangle.height / 2 - 10) }
        @sub_elements[:load_program_button] = Button.new(@root, "Edit")
        .constrain{ Rectangle2.new(@rectangle.right - BUTTON_WIDTH - 5, @rectangle.y + 5, BUTTON_WIDTH, @rectangle.height - 10) }
        .add_event(:click, options = {button: Gosu::MS_LEFT}){ self.edit }
        super
    end
    def edit
        res = system("code #{@path_file}")
        res = system("notepad++ #{@path_file}") if res.nil?
        res = system("notepad #{@path_file}") if res.nil?
    end
    def path_file= path_file
        @sub_elements[:filename].string = File.basename(path_file)
        @path_file = path_file
    end
end