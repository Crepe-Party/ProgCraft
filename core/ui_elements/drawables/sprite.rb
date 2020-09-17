# sprite
class Sprite
    attr_accessor :pos_x, :pos_y
    def initialize img_path, frame_width, frame_height
        @tileset = Gosu::Image.load_tiles(@img_path, frame_width, frame_height)
        @tileset_height = @tileset.size
        @tileset_width = @tileset.first.size
        @tile = {x => 0, y => 0}
    end
    def update
        @tile.x = (@tile.x + 1) % @tileset_width
        @tile.y = (@tile.y + 1) % @tileset_height if @tile.x == 0
    end
    def draw
        @tileset[@tile.x, @tile.y].draw(@pos_x, @pos_y, 1)
    end
end