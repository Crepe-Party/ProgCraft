require_relative '../ui_element'
class GridGameContainer < UIElement
    def initialize game, rectangle=nil, &constraint
        @grid_color = Gosu::Color::GRAY
        @bg_color = Gosu::Color::GREEN
        @zoom_level = 1
        @grid_size = Vector2.new(50, 40)
        super game, rectangle, &constraint
    end
    def build
        @overflow = :hidden
    end
end