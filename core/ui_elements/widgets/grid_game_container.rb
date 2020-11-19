require_relative '../drawables/drawable'
class GridGameContainer < Drawable
    CONTINUOUS_SCROLL_FACTOR = 200
    INSTANT_SCROLL_FACTOR = 40
    INSTANT_ZOOM_FACTOR = 1.1
    attr_accessor :camera_position, :selected_map
    def initialize root, &constraint
        @grid_color = Gosu::Color::GRAY
        @bg_color = Gosu::Color::GREEN
        @camera_zoom = 1
        @camera_zoom_origin = Vector2.new
        @camera_position = Vector2.new(0,0)
        @map_size = Vector2.new(8,5)
        @grid_size = Vector2.new(100, 100)
        @grid_weight = 2
        @selected_map = nil
        super root, &constraint
    end
    def build
        super
        self.add_event(:mouse_down, button: Gosu::MS_WHEEL_DOWN) do |event|
            if (@root.window.button_down? Gosu::KB_LEFT_SHIFT) || (@root.window.button_down? Gosu::KB_RIGHT_SHIFT)
                scroll(:right, INSTANT_SCROLL_FACTOR)
            elsif(zoomable? && (@root.window.button_down? Gosu::KB_LEFT_CONTROL) || (@root.window.button_down? Gosu::KB_RIGHT_CONTROL))
                zoom(1.0/INSTANT_ZOOM_FACTOR, event[:position])
            else
                scroll(:down, INSTANT_SCROLL_FACTOR)
            end
        end
        self.add_event(:mouse_down, button: Gosu::MS_WHEEL_UP) do |event|
            if(@root.window.button_down? Gosu::KB_LEFT_SHIFT) || (@root.window.button_down? Gosu::KB_RIGHT_SHIFT)
                scroll(:left, INSTANT_SCROLL_FACTOR)
            elsif(zoomable? && (@root.window.button_down? Gosu::KB_LEFT_CONTROL) || (@root.window.button_down? Gosu::KB_RIGHT_CONTROL))
                zoom(INSTANT_ZOOM_FACTOR, event[:position])
            else
                scroll(:up, INSTANT_SCROLL_FACTOR)
            end
        end
        self.add_event(:mouse_drag, button: Gosu::MS_MIDDLE) do |event|
            next unless scrollable?
            @camera_position.add!((event[:last_position] - event[:position]))
        end
        self.add_event(:button_down, button: 'r'){reset_camera}


        #test
        self.add_event(:click) do |event|
            puts event
            @test_click_pos = event[:position]
            @test_map_pos = projected_position(event[:position])
            @test_grid_pos = projected_grid_position(event[:position])
            p @test_grid_pos
        end
    end
    def update dt
        super dt
        if scrollable?
            scrl_dist = dt * CONTINUOUS_SCROLL_FACTOR
            scroll(:up, scrl_dist) if @root.window.button_down? Gosu::KB_UP
            scroll(:down, scrl_dist) if @root.window.button_down? Gosu::KB_DOWN
            scroll(:left, scrl_dist) if @root.window.button_down? Gosu::KB_LEFT
            scroll(:right, scrl_dist) if @root.window.button_down? Gosu::KB_RIGHT
        end
    end
    def draw
        camera_real_position = (@camera_position * -1).add! @rectangle.position
        #bg color
        Gosu.clip_to(@rectangle.x, @rectangle.y, @rectangle.width, @rectangle.height) do
            self.background_elem.draw if self.background_elem
            Gosu.scale(@camera_zoom, @camera_zoom, @camera_zoom_origin.x, @camera_zoom_origin.y) do
                Gosu.translate(camera_real_position.x, camera_real_position.y) do
                    #tiles
                    #TODO: tiles
                    #grid
                    0.upto(@map_size.x) do |index|
                        Gosu.draw_rect(index * @grid_size.x - (@grid_weight / 2), 0, @grid_weight, @map_size.y * @grid_size.y, @grid_color)
                    end
                    0.upto(@map_size.y) do |index|
                        Gosu.draw_rect(0, index * @grid_size.y - (@grid_weight / 2), @map_size.x * @grid_size.x, @grid_weight, @grid_color)
                    end
                    #game elements
                    unless @selected_map.nil?
                        @selected_map.game_objects.each do |game_object|
                            game_object.draw game_object.position.x * @grid_size.x, game_object.position.y * @grid_size.y
                        end
                    end

                    #test
                    Gosu.draw_rect(@test_map_pos.x - 5, @test_map_pos.y - 5, 20, 20, Gosu::Color::RED) if @test_map_pos
                    Gosu.draw_rect(@test_grid_pos.x * @grid_size.x, @test_grid_pos.y * @grid_size.y, @grid_size.x, @grid_size.y, Gosu::Color::rgba(0,0,255,100)) if @test_grid_pos
                end
            end
        end
        # click pos
        Gosu.draw_rect(@test_click_pos.x, @test_click_pos.y, 10, 10, Gosu::Color::BLUE) if @test_click_pos
    end
    def reset_camera
        @camera_position.assign!(x:0, y:0)
        @camera_zoom = 1
    end
    def scrollable?
        true
    end
    def zoomable?
        true
    end
    def scroll(direction, distance)
        return unless scrollable?
        self.camera_position.y -= distance if direction == :up
        self.camera_position.y += distance if direction == :down
        self.camera_position.x -= distance if direction == :left
        self.camera_position.x += distance if direction == :right
    end
    def zoom factor, origin = rectangle.center
        @camera_zoom*=factor
        @camera_zoom_origin = origin
    end
    def projected_position(screen_pos)
        (screen_pos - @rectangle.position).add!(@camera_position)
    end
    def grid_position position
        (position / @grid_size).floor!
    end
    def projected_grid_position(screen_pos)
        proj_pos = projected_position screen_pos
        p "proj", proj_pos
        grid_pos = grid_position proj_pos
        p "gpos", grid_pos
        grid_pos
    end
end