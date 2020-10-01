require_relative '../../ui_elements/ui_element'
require_relative '../../ui_elements/widgets/button'
class GameTopBar < UIElement
    MAPS_DIR_MAP = File.join(File.dirname(__FILE__), '../../../MyMaps/')
    MAPS_DIR_CODES = File.join(File.dirname(__FILE__), '../../../mycodes/')
    def build
        self.background_color = Gosu::Color::GRAY
        @sub_elements[:load_map_button] = Button.new(@game, "Load Map")
            .constrain{Rectangle2.new(@rectangle.right - 150- 5, @rectangle.y + 5, 150, 40)}
            .add_event(:mouse_down, options = {button: Gosu::MS_LEFT}){
                @game.busy = true
                @game.window_manager.open_file(MAPS_DIR_MAP) do |path_file| 
                    @game.load_map path_file
                    @game.busy = false
                end
            }
        @sub_elements[:load_program_button] = Button.new(@game, "Load Program")
            .constrain{Rectangle2.new(@rectangle.right - 300 - 15, @rectangle.y + 5, 150, 40)}
            .add_event(:mouse_down, options = {button: Gosu::MS_LEFT}){
                @game.busy = true
                @game.window_manager.open_file(MAPS_DIR_CODES, default_extension: 'rb', filetypes: "{{Ruby program} {.rb}}") do |path_file| 
                    @game.load_program path_file
                    @game.busy = false
                end
            }
                
        @sub_elements[:save_program_button] = Button.new(@game, "Save Program")
            .constrain{Rectangle2.new(@rectangle.right - 450 - 25, @rectangle.y + 5, 150, 40)}
            .add_event(:mouse_down, options = {button: Gosu::MS_LEFT}){
                @game.busy = true
                @game.window_manager.save_file(MAPS_DIR_CODES, default_extension: 'rb', filetypes: "{{Ruby program} {.rb}}") do |path_file| 
                    @game.save_program path_file
                    @game.busy = false
                end
            }
        super
    end
end