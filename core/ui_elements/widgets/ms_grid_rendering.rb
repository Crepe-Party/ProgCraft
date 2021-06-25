class GridRenderPipeline
    def initialize map_elem
        #consts
        @TILES_SIZE = 64
        @GRID_WIDTH = 10
        @GRID_HEIGHT = 10
        @GRID_WIDTH, @GRID_HEIGHT, @SUBRENDER_COUNT = [10, 10, 10]
        @FLAG_COLOR = Gosu::Color.new(255, 0, 0)
        @CLIPPING_RANGE = [[50, 255, 50], [255, 50, 50]]
        @FONT1 = Gosu::Font.new(@TILES_SIZE, name:Gosu::default_font_name)
        @FONT2 = Gosu::Font.new(@TILES_SIZE * 2, name: Gosu::default_font_name)
        @SAFE_LANDING_RADIUS = 1
        #init-reset
        @map_elem = map_elem
        grid_map = Map.new
        grid_map.size = Vector2.new(@GRID_WIDTH,@GRID_HEIGHT)
        @map_elem.selected_map = grid_map
        @map_elem.robert = nil
        #prebuild
        @map_elem.sub_elements[:count_display] = Text.new(@map_elem.root, "", font_size: 30, color: Gosu::Color::RED)
            .constrain{r = @map_elem.rectangle; r.relative_to(x: r.width - 50).assign!(width: 50, height: 30)}
        @map_elem.sub_elements[:info_display] = Text.new(@map_elem.root, "", font: @FONT2){@map_elem.rectangle}
        @map_elem.add_event(:click) {|evt| on_click(evt[:position], :left)}
            .add_event(:click, button: Gosu::MS_RIGHT){|evt| on_click(evt[:position], :right)}
            .apply_constraints
        #start
        restart
    end
    
    def restart
        @render_status = :ready
        @flags_count = 0
        @subrenders_map = Array.new(@GRID_WIDTH).map{Array.new(@GRID_HEIGHT)}
        @proximity_map = Array.new(@GRID_WIDTH).map{Array.new(@GRID_HEIGHT)}
        @flags_map = Array.new(@GRID_WIDTH).map{Array.new(@GRID_HEIGHT).fill(false)}
        draw
    end

    def gen_map spawn_x, spawn_y
        #create array
        @SUBRENDER_COUNT.times do
            loop do
                x = rand @GRID_WIDTH
                y = rand @GRID_HEIGHT
                next if @subrenders_map[x][y] || (x.between?(spawn_x-@SAFE_LANDING_RADIUS, spawn_x+@SAFE_LANDING_RADIUS) && y.between?(spawn_y-@SAFE_LANDING_RADIUS, spawn_y+@SAFE_LANDING_RADIUS))
                @subrenders_map[x][y] = :subrender
                break
            end
        end
        #proximity map
        @GRID_WIDTH.times do |x|
            @GRID_HEIGHT.times do |y|
                rel_count = 0
                3.times do |x_off|
                    x_pos = x + x_off - 1
                    next unless x_pos.between? 0, @GRID_WIDTH-1
                    3.times do |y_off|
                        y_pos = y + y_off - 1
                        next unless y_pos.between? 0, @GRID_WIDTH-1
                        tile = @subrenders_map[x_pos][y_pos]
                        rel_count+=1 if tile && tile == :subrender
                    end
                end
                @proximity_map[x][y] = rel_count
            end
        end
        draw
    end

    def draw
        new_map_elems = []
        @GRID_WIDTH.times do |x|
            @GRID_HEIGHT.times do |y|
                vecpos = Vector2.new(x,y)
                tile_content = @subrenders_map[x][y]
                tile_type = :subrender if tile_content == :subrender && @render_status == :failure
                tile_type = :subrender_complete if tile_content == :subrender && @render_status == :success
                tile_type = :clear if tile_content == :clear
                tile_type = :default unless tile_type 

                case tile_type
                when :subrender
                    new_map_elems.push GameObjects::Apple.new(position:vecpos)
                when :subrender_complete
                    new_map_elems.push Robert.new(nil, x, y)
                when :default
                    new_map_elems.push GameObjects::Bush.new(position:vecpos)
                end

                
                if @proximity_map[x][y] && tile_content == :clear && @proximity_map[x][y] != 0
                    clip_color = Gosu::Color.new(
                        (@CLIPPING_RANGE[1][0] - @CLIPPING_RANGE[0][0])*(@proximity_map[x][y]/8.0) + @CLIPPING_RANGE[0][0],
                        (@CLIPPING_RANGE[1][1] - @CLIPPING_RANGE[0][1])*(@proximity_map[x][y]/8.0) + @CLIPPING_RANGE[0][1],
                        (@CLIPPING_RANGE[1][2] - @CLIPPING_RANGE[0][2])*(@proximity_map[x][y]/8.0) + @CLIPPING_RANGE[0][2],
                    )
                    new_map_elems.push GameObjects::Letter.new(letter: @proximity_map[x][y], font: @FONT1, color: clip_color, position: vecpos)
                end

                if @flags_map[x][y] && (tile_type == :default || @render_status == :failure)
                    new_map_elems.push GameObjects::Bush::new(position: Vector2.new(x,y), img_path: "bush_christmas_64x.png")
                end
            end
        end
        #apply
        @map_elem.selected_map.game_objects = new_map_elems
        #update ui
        @map_elem.sub_elements[:count_display].string = @SUBRENDER_COUNT - @flags_count
        @map_elem.sub_elements[:info_display].string = @render_status == :success ? "Won!" : @render_status == :failure ? "Lost!" : ""
        @map_elem.sub_elements[:info_display].color = @render_status == :success ? Gosu::Color.new(0, 255, 0) : Gosu::Color.new(255, 0, 0)
    end
    def on_click clicked_pos, key
        return restart unless @render_status == :rendering || @render_status == :ready

        clicked_pos = @map_elem.projected_grid_position(clicked_pos)
        tile_x, tile_y = clicked_pos.to_a
        return unless pos_in_map?(tile_x, tile_y)

        clear_tile(tile_x, tile_y) if key == :left
        toggle_flag(tile_x, tile_y) if key == :right

        draw
    end
    def toggle_flag x, y
        return unless @render_status == :rendering || @render_status == :ready
        return unless @subrenders_map[x][y] == nil || @subrenders_map[x][y] == :subrender
        @flags_map[x][y] = !@flags_map[x][y]
        @flags_count = get_count_in_array(@flags_map, true)
    end
    def clear_tile x, y
        if @render_status == :ready
            @start_timestamp = Time.now
            gen_map(x,y)
            @render_status = :rendering
        end
        return unless @render_status == :rendering
        return if @subrenders_map[x][y] == :clear
        return if @flags_map[x][y]
        return abort_render if @subrenders_map[x][y] == :subrender
        soft_clear x, y

        return abort_render(:success) if (@GRID_WIDTH * @GRID_HEIGHT - get_count_in_array(@subrenders_map, :clear)) == @SUBRENDER_COUNT
    end
    def soft_clear x, y, should_reset_visited=true
        return unless pos_in_map? x, y
        @visited_map = Array.new(@GRID_WIDTH).map{Array.new(@GRID_HEIGHT).fill(false)} if should_reset_visited
        return if @visited_map[x][y]
        @visited_map[x][y] = true
        return if @subrenders_map[x][y] == :subrender
        return if @flags_map[x][y]
        @subrenders_map[x][y] = :clear
        return if @proximity_map[x][y] > 0
        3.times do |x_off|
            x_pos = x + x_off - 1
            3.times do |y_off|
                next if x_off == 1 && y_off == 1
                y_pos = y + y_off - 1
                soft_clear x_pos, y_pos, false
            end
        end
    end
    def pos_in_map? (x, y)
        x.between?(0, @GRID_WIDTH - 1) && y.between?(0, @GRID_HEIGHT - 1)
    end
    def abort_render state = :failure
        @render_status = state
    end
    def get_count_in_array array, data_val
        array.reduce(0){|sum, data| sum + data.count(data_val)}
    end
end

def dispatch_render map_elem
    GridRenderPipeline.new map_elem
end