require_relative '../../ui_elements/ui_element'
require_relative '../../ui_elements/widgets/button'
class EditorTopBar < UIElement
    MAPS_DIR = File.join(File.dirname(__FILE__), '../../../MyMaps/')
    def build
        self.background_color = Gosu::Color::GRAY
        @sub_elements[:open_button] = Button.new(@root, "Open")
            .constrain{Rectangle2.new(@rectangle.x + 10, @rectangle.y + 5, 200, 40)}
            .add_event(:mouse_down, {button: Gosu::MS_LEFT}) do 
                @root.busy = true
                @root.load_map @root.window_manager.open_file initial_dir: MAPS_DIR, patterns: ["Json files (*.json)", "ProgCraft Maps (*.json)"], preferred_file_filter: 1
                @root.busy = false
            end       
            
        @sub_elements[:save_button] = Button.new(@root, "Save")
            .constrain{Rectangle2.new(@rectangle.right - 200 - 10, @rectangle.y + 5, 200, 40)}
            .add_event(:mouse_down, {button: Gosu::MS_LEFT}) do
                @root.busy = true
                @root.save_map @root.window_manager.save_file initial_dir: MAPS_DIR, patterns: ["Json files (*.json)", "ProgCraft Maps (*.json)"], preferred_file_filter: 1
                @root.busy = false
            end
        super
    end
end