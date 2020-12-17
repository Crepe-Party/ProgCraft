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
        def solid?
            true
        end
    end
    class Door < Interactable

    end
    class Log < Interactable

    end
    class Tree < Interactable
        def solid?
            true
        end
    end
    class PineCone < Interactable
        def self.default_texture
            "pine_cone_64x.png"
        end
        def self.pretty_s
            "Pine cone"
        end
    end
    class Wall < GameObject
        def solid?
            true
        end
        def self.default_texture
            "wall_64x.png"
        end
    end
end
