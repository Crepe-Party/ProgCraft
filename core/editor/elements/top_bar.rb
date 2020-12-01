require_relative '../../ui_elements/ui_element'
require_relative '../../ui_elements/widgets/button'
require_relative '../../ui_elements/drawables/text'
require_relative '../../config'
class EditorTopBar < UIElement
    attr_reader :level_path
    def build
        self.background_color = Gosu::Color::GRAY

        @sub_elements[:open_button] = Button.new(@root, "Open")
            .constrain{@rectangle.relative_to(x: 10, y: 5).assign!(width: 200, height: 40)}
            .add_event(:mouse_down, {button: Gosu::MS_LEFT}) do 
                @root.load_map @root.window_manager.open_file initial_dir: Config::MY_MAPS_DIR, patterns: ["Json files (*.json)", "ProgCraft Maps (*.json)"], preferred_file_filter: 1
            end
        
        @sub_elements[:map_path] = Text.new(@root, center_text: false, font_size: 20)
            .constrain{@sub_elements[:open_button].rectangle.relative_to(x: 210, y: 15).assign!(height: 20)}

        @sub_elements[:new_button] = Button.new(@root, "New")
            .constrain{@sub_elements[:open_button].rectangle.assign(x: @rectangle.right - 60, width: 50)}
            .add_event(:click){ @root.new_level }

        @sub_elements[:save_as_button] = Button.new(@root, "Save as")
            .constrain{@sub_elements[:open_button].rectangle.assign(x: @rectangle.right - 210 - 60)}
            .add_event(:mouse_down, {button: Gosu::MS_LEFT}) do
                @root.save_map @root.window_manager.save_file initial_dir:  Config::MY_MAPS_DIR, patterns: ["Json files (*.json)", "ProgCraft Maps (*.json)"], preferred_file_filter: 1
            end

        @sub_elements[:save_button] = Button.new(@root, "Save")
            .constrain{self.level_path ? @sub_elements[:save_as_button].rectangle.relative_to(x: -210) : Rectangle2.new}
            .add_event(:click){ @root.save_map(self.level_path) }
        
        super
    end
    def level_path= path
        @level_path = path
        @sub_elements[:map_path].string = path ? File.basename(path) : "New Level..."
        self.apply_constraints
    end
end