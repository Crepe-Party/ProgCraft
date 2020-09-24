require_relative './tools/vector'
class GameObject
    attr :id, :name, :texture, :position 
    def initialize id=nil, name=nil , texture='../assets/basic_texture.png', position=Vector2.new(0,0)
        @id, @name, @texture, @position = id, name, Gosu::Image.new(texture), position 
    end 
    def draw
        @texture.draw(@position.x, @position.y, 0)
    end
end