require_relative 'interactable'
module GameObjects
    class Apple < Interactable
        
    end
    class Axe < Interactable
        
    end
    class Bush < Interactable
        def self.default_texture
            "bush_64x.png"
        end
    end
    class Door < Interactable

    end
    class Log < Interactable

    end
    class Tree < Interactable

    end
    class PineCone < Interactable
        def self.default_texture
            "pine_cone_64x.png"
        end
        def self.to_s
            "Pine cone"
        end
    end
    class Wall < GameObject
        def self.default_texture
            "wall_64x.png"
        end
    end
end
