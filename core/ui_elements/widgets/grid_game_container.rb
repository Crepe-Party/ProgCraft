require_relative '../drawables/drawable'
class GridGameContainer < Drawable
    CONTINUOUS_SCROLL_FACTOR = 200
    INSTANT_SCROLL_FACTOR = 40
    attr_accessor :camera_position
    def initialize root, &constraint
        @grid_color = Gosu::Color::GRAY
        @bg_color = Gosu::Color::GREEN
        @camera_zoom = 1
        @camera_position = Vector2.new(0,0)
        @map_size = Vector2.new(6,4)
        @grid_size = Vector2.new(100, 80)
        @grid_weight = 2
        @game_objects = []
        super root, &constraint
    end
    def build
        super
        self.add_event(:mouse_down, button: Gosu::MS_WHEEL_DOWN) do
            if (@root.window.button_down? Gosu::KB_LEFT_SHIFT) || (@root.window.button_down? Gosu::KB_RIGHT_SHIFT)
                scroll(:right, INSTANT_SCROLL_FACTOR)
            else
                scroll(:down, INSTANT_SCROLL_FACTOR)
            end
        end
        self.add_event(:mouse_up, button: Gosu::MS_WHEEL_UP) do
            if (@root.window.button_down? Gosu::KB_LEFT_SHIFT) || (@root.window.button_down? Gosu::KB_RIGHT_SHIFT)
                scroll(:left, INSTANT_SCROLL_FACTOR)
            else
                scroll(:up, INSTANT_SCROLL_FACTOR)
            end
        end
    end
    def update dt
        super dt
        scrl_dist = dt * CONTINUOUS_SCROLL_FACTOR
        scroll(:up, scrl_dist) if @root.window.button_down? Gosu::KB_UP
        scroll(:down, scrl_dist) if @root.window.button_down? Gosu::KB_DOWN
        scroll(:left, scrl_dist) if @root.window.button_down? Gosu::KB_LEFT
        scroll(:right, scrl_dist) if @root.window.button_down? Gosu::KB_RIGHT
    end
    def draw
        camera_real_position = (@camera_position * -1).add! @rectangle.position
        camera_center_position = camera_real_position + (@rectangle.size / 2)
        #bg color
        Gosu.clip_to(@rectangle.x, @rectangle.y, @rectangle.width, @rectangle.height) do
            Gosu.scale(1, 1, camera_center_position.x, camera_center_position.y) do
                Gosu.translate(camera_real_position.x, camera_real_position.y) do
                    Gosu.draw_rect(0,0,50,50,Gosu::Color::BLUE)
                    #tiles
                    #TODO: tiles
                    #grid
                    0.upto(@map_size.x) do |index|
                        Gosu.draw_rect(index * @grid_size.x - (@grid_weight / 2), 0, @grid_weight, @map_size.y * @grid_size.y, @grid_color)
                        # Gosu.draw_rect() 
                    end
                    0.upto(@map_size.y) do |index|
                        Gosu.draw_rect(0, index * @grid_size.y - (@grid_weight / 2), @map_size.x * @grid_size.x, @grid_weight, @grid_color)
                        # Gosu.draw_rect() 
                    end
                    #game elements
                end
            end
        end
    end
    def scrollable?
        true
    end
    def scroll direction, distance
        return unless scrollable?
        self.camera_position.y -= distance if direction == :up
        self.camera_position.y += distance if direction == :down
        self.camera_position.x -= distance if direction == :left
        self.camera_position.x += distance if direction == :right
    end
end