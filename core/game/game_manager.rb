require 'pp'
require_relative '../app_manager'
require_relative 'elements/game_ui'
require_relative '../level'
require_relative '../game_objects/player'
class GameManager < AppManager
    attr :level, :player
    def initialize window
        super window, main_ui_class: GameUI
        @busy_string = "Loading..."
        @level = Level.new
        @player = Player.new(600, 300)
    end
    def load_map path_file
        @level_available = @level.load path_file
        @player.set_pos @level.maps[0].robert_spawn.x, @level.maps[0].robert_spawn.y unless @level_available.nil?
    end
    def load_program path_file
        @game_ui.sub_elements[:code_display].load path_file
    end
    def save_program path_file
        
    end
end