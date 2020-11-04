require_relative '../../ui_elements/ui_element'
require_relative '../../ui_elements/widgets/button'
class GameTopBar < UIElement
    MAPS_DIR_MAP = File.join(File.dirname(__FILE__), '../../../MyMaps/')
    MAPS_DIR_CODES = File.join(File.dirname(__FILE__), '../../../mycodes/')
    def build
        self.background_color = Gosu::Color::GRAY
        @sub_elements[:play_button] = Button.new(@root, "", background_image: 'icons/forward.png', background_image_cover: true)
            .constrain{Rectangle2.new(@rectangle.x + 5, @rectangle.y + 5, 40, 40)}
            .add_event(:mouse_down, options = {button: Gosu::MS_LEFT}){
                @root.busy = true
                @root.window_manager.open_file(MAPS_DIR_MAP) do |path_file| 
                    @root.load_map path_file
                    @root.busy = false
                end
            }
        @sub_elements[:pause_button] = Button.new(@root, "", background_image: 'icons/pause.png', background_image_cover: true)
            .constrain{Rectangle2.new(@rectangle.x + 50, @rectangle.y + 5, 40, 40)}
            .add_event(:mouse_down, options = {button: Gosu::MS_LEFT}){
                @root.busy = true
                @root.window_manager.open_file(MAPS_DIR_MAP) do |path_file| 
                    @root.load_map path_file
                    @root.busy = false
                end
            }
        @sub_elements[:next_button] = Button.new(@root, "", background_image: 'icons/next.png', background_image_cover: true)
            .constrain{Rectangle2.new(@rectangle.x + 95, @rectangle.y + 5, 40, 40)}
            .add_event(:mouse_down, options = {button: Gosu::MS_LEFT}){
                @root.busy = true
                @root.window_manager.open_file(MAPS_DIR_MAP) do |path_file| 
                    @root.load_map path_file
                    @root.busy = false
                end
            }
        @sub_elements[:load_map_button] = Button.new(@root, "Load Map")
            .constrain{Rectangle2.new(@rectangle.right - 300 - 15, @rectangle.y + 5, 150, 40)}
            .add_event(:mouse_down, options = {button: Gosu::MS_LEFT}){
                @root.busy = true
                @root.window_manager.open_file(MAPS_DIR_MAP) do |path_file| 
                    @root.load_map path_file
                    @root.busy = false
                end
            }
        @sub_elements[:load_program_button] = Button.new(@root, "Load Program")
            .constrain{Rectangle2.new(@rectangle.right - 150- 5, @rectangle.y + 5, 150, 40)}
            .add_event(:mouse_down, options = {button: Gosu::MS_LEFT}){
                @root.busy = true
                @root.window_manager.open_file(MAPS_DIR_CODES, default_extension: 'rb', filetypes: "{{Ruby program} {.rb}}") do |path_file| 
                    @root.load_program path_file
                    @root.busy = false
                end
            }
        super
    end
end