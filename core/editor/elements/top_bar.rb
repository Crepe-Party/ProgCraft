require_relative '../../ui_elements/ui_element'
require_relative '../../ui_elements/widgets/button'
class EditorTopBar < UIElement
    MAPS_DIR = File.join(File.dirname(__FILE__), '../../../MyMaps/')
    def build
        self.background_color = Gosu::Color::GRAY
        @sub_elements[:open_button] = Button.new(@root, "Open")
            .constrain{Rectangle2.new(@rectangle.x + 10, @rectangle.y + 5, 200, 40)}
            .add_event(:mouse_down, {button: Gosu::MS_LEFT}) do 
                system("explorer .\\MyMaps") #TODO REMOVE and chancge TO UNIVERSAL PLATFORM
                #when we click on open file button, show a screen where we can drop file to load
                @root.main_ui.sub_elements[:Loader_files]= Class.new(UIElement) do 
                    def build
                        self.background_color=Gosu::Color.rgba(255, 255, 255, 150)
                        @sub_elements[:background_text_1] = Text.new(@root, "Drag and drop your file here...", center_text: true, color: Gosu::Color::BLACK, font_size: 50){@rectangle.relative_to(y: -50)}
                        @sub_elements[:background_text_2] = Text.new(@root, "Or press ESC to cancel the upload of file.", center_text: true, color: Gosu::Color::BLACK, font_size: 50){@rectangle}
                    end
                end.new(@root){Rectangle2.new(0, 0, @root.window.width, @root.window.height)}
                @root.main_ui.sub_elements[:Loader_files]
                .add_event(:drop) do |event|
                    file_extension = File.extname(event[:filename])
                    if file_extension == ".json"
                        @root.load_map event[:filename] 
                        @root.events_manager.remove_event(@root.main_ui.sub_elements[:Loader_files])
                        @root.main_ui.sub_elements.delete(:Loader_files)
                    end
                end
                .add_event(:button_down, {button: Gosu::KB_ESCAPE}) do                    
                    @root.main_ui.sub_elements.delete(:Loader_files)
                end
                @root.main_ui.apply_constraints
            end       
            
        @sub_elements[:save_button] = Button.new(@root, "Save")
            .constrain{Rectangle2.new(@rectangle.right - 200 - 10, @rectangle.y + 5, 200, 40)}
            .add_event(:mouse_down, {button: Gosu::MS_LEFT}) do
                # @root.busy = true
                # @root.window_manager.save_file(MAPS_DIR) do |path_file|
                #     @root.save_map path_file
                #     @root.busy = false
                # end
            end
        super
    end
end