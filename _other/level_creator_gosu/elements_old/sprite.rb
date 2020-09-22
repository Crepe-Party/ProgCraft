class SpriteElement < Element
    attr_accessor :sprite
    attr_accessor :abs_pos_x
    attr_accessor :abs_pos_y
    def initialize (x: ,y:, parent)
        super (x:x, y:y, parent:parent)
        @sprite = Sprite.new
    end
    def draw

        self
    end
    def final_draw abs_x, abs_y
        
    end
end