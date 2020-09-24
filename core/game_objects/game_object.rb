class GameObject
    attr :position, :texture, :name, :id
    def initialize name=nil, id=nil, texture='basic_texture.png', position=Vector2.new(0,0)
        @name, @id, @name, @texture = name, id, texture, position 
    end 
end