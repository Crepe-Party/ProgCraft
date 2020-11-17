require_relative 'interactable'
module GameObjects
    class Apple < Interactable
        
    end
    class Axe < Interactable
        
    end
    class Bush < Interactable
        def self.default_texture
            "basic_bush.png"
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
            "pine_cone_x64.png"
        end
    end
    class Wall < GameObject
        def self.default_texture
            "wall.png"
        end
    end
end
