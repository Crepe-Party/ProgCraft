require_relative '../../ui_elements/ui_element'
require_relative '../../ui_elements/widgets/button'
require_relative '../../config'
class GameTopBar < UIElement
    def build
        self.background_color = Gosu::Color::GRAY
        @sub_elements[:stop_button] = Button.new(@root, background_image: 'icons/stop.png', background_image_cover: true)
            .constrain{@rectangle.relative_to(x:5, y:5, height:-10).assign!(width:40)}
            .on_click{@root.stop}
        @sub_elements[:play_button] = Button.new(@root, "", background_image: 'icons/forward.png', background_image_cover: true)
            .constrain{@sub_elements[:stop_button].rectangle.relative_to(x: 50)}
            .on_click{ @root.play }
        @sub_elements[:pause_button] = Button.new(@root, "", background_image: 'icons/pause.png', background_image_cover: true)
            .constrain{@sub_elements[:play_button].rectangle.relative_to(x: 50)}
            .on_click{ @root.pause }
        @sub_elements[:next_button] = Button.new(@root, "", background_image: 'icons/next.png', background_image_cover: true)
            .constrain{@sub_elements[:pause_button].rectangle.relative_to(x: 50)}
            .on_click{ @root.next }
        @sub_elements[:load_map_button] = Button.new(@root, "Load Map")
            .constrain{Rectangle2.new(@rectangle.right - 300 - 15, @rectangle.y + 5, 150, 40)}
            .on_click do
                @root.busy = true
                @root.load_map @root.window_manager.open_file initial_dir: Config::MY_MAPS_DIR, patterns: ["Json files (*.json)", "ProgCraft Maps (*.json)"], preferred_file_filter: 1
                @root.busy = false
            end
        @sub_elements[:load_program_button] = Button.new(@root, "Load Program")
            .constrain{ Rectangle2.new(@rectangle.right - 150 - 5, @rectangle.y + 5, 150, 40) }
            .on_click do
                @root.busy = true
                @root.load_program @root.window_manager.open_file initial_dir: Config::MY_CODES_DIR, patterns: ["Ruby programs (*.rb)"], preferred_file_filter: 0
                @root.busy = false
            end
        super
    end
end