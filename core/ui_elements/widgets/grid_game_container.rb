require_relative '../drawables/drawable'
class GridGameContainer < Drawable
    def initialize root, &constraint
        @grid_color = Gosu::Color::GRAY
        @bg_color = Gosu::Color::GREEN
        @camera_zoom = 1
        @camera_position = Vector2.new
        @grid_size = Vector2.new(50, 40)
        @game_objects = []
        super root, &constraint
    end
    def build
        @overflow = :hidden
    end
    def draw
        
    end
end