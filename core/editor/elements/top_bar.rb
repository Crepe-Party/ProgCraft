require_relative '../../ui_elements/ui_element'
require_relative '../../ui_elements/widgets/button'
require 'tk'
class EditorTopBar < UIElement
    MAPS_DIR = File.join(File.dirname(__FILE__), '../../../MyMaps/')
    def build
        self.background_color = Gosu::Color::GRAY
        @sub_elements[:open_button] = Button.new(@game, "Open")
            .constrain{Rectangle2.new(@rectangle.x + 10, @rectangle.y + 5, 200, 40)}
            .add_event(:mouse_down, options = {button: Gosu::MS_LEFT}){
                @game.load_map Tk.getOpenFile(  'title' => 'Select Files',
                    'multiple' => false, 
                    'defaultextension' => 'json',
                    'initialdir' => MAPS_DIR,
                    'filetypes' => "{{ProgCraft map} {.json}}")
            }
                
        @sub_elements[:save_button] = Button.new(@game, "Save")
            .constrain{Rectangle2.new(@rectangle.right - 200 - 10, @rectangle.y + 5, 200, 40)}
            .add_event(:mouse_down, options = {button: Gosu::MS_LEFT}){
                @game.save_map Tk.getSaveFile( 'title' => 'Save a ProgCraft map',
                    'defaultextension' => 'json',
                    'initialfile' => Time.now.strftime("%Y-%m-%d"),
                    'initialdir' => MAPS_DIR,
                    'filetypes' => "{{ProgCraft map} {.json}}")
            }
        super
    end
end