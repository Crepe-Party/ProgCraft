require 'pp'
require_relative '../app_manager'
require_relative 'elements/editor_ui'
require_relative '../level'
require_relative '../game_objects/player'
class EditorManager < AppManager
    attr :level, :player
    def initialize window 
        super window, main_ui_class: EditorUI
        @busy_string = "Loading..."
        new_level
    end
    def load_map path_file
        @level_available = @level.load path_file
        if @level_available
            change_map(0)
        end
    end
    def new_level
        @level = Level.new
        change_map(0)
    end
    def change_map index
        @selected_map_index = index
        @main_ui.sub_elements[:map_editor].selected_map = @level.maps[index]
    end
    def save_map path_file
        @level.save path_file
    end
end