require 'pp'
require_relative 'elements/editor_ui'
require_relative '../events/events_manager'
require_relative '../level'
require_relative '../game_objects/player'
class EditorManager
    attr_reader :window, :editor_ui, :events_manager
    attr :level, :player
    def initialize window
        @events_manager = EventsManager.new window
        @window = window
        @editor_ui = EditorUI.new self, Rectangle2.new(0,0)
        @keys_down = []
        @level = Level.new
        @player = Player.new(600, 300)
    end
    def update dt
        @editor_ui.update dt
        @events_manager.update
    end
    def render
        # final draw
        elements_to_draw = @editor_ui.render.flatten
        elements_to_draw.each{|drawable| drawable.draw_with_clipping}
        # temp TODO remove
        clip_rect =  @editor_ui.sub_elements[:map_editor].rectangle
        Gosu.clip_to clip_rect.x, clip_rect.y, clip_rect.width, clip_rect.height do
            x = 5
            grid_size = 50
            while x < window.width do
                Gosu.draw_line(x, 0, Gosu::Color.new(200,200,200), x, window.height, Gosu::Color.new(200,200,200))
                x+=grid_size
            end
            y = 65
            while y < window.height do
                Gosu.draw_line(0, y, Gosu::Color.new(200,200,200), window.width, y, Gosu::Color.new(200,200,200))
                y+=grid_size
            end
            @level.render 0
            @player.draw
        end
    end
    def apply_constraints
        @editor_ui.rectangle.width = window.width
        @editor_ui.rectangle.height = window.height
        @editor_ui.apply_constraints
    end
    def load_map path_file
        @level.load path_file
        @player.set_pos @level.maps[0].player_spawn.x, @level.maps[0].player_spawn.y
    end

    def add_event element, type, options = {}, &handler
        @events_manager.add_event(element, type, options, handler)
    end
end