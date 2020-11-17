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
        @level = Level.new
        @player = Player.new(600, 300)
    end
    def load_map path_file
        @level_available = @level.load path_file
        if @level_available
            @main_ui.sub_elements[:map_editor].selected_map = @level.maps[0] 
            @player.set_pos @level.maps[0].robert_spawn.x, @level.maps[0].robert_spawn.y
        end
    end
    def save_map path_file
        @level.save path_file
    end
end