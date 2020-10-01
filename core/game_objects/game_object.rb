require_relative '../tools/vector'
class GameObject
    attr :id, :name, :texture, :position, :img_path 
    def initialize id=nil, name=nil , img_path='basic_texture.png', position=Vector2.new(0,0)
        @id, @name, @texture, @position, @img_path = id, name, Gosu::Image.new("#{__dir__}/../assets/#{img_path}"), position, img_path 
    end 
    def draw
        @texture.draw(@position.x, @position.y, 0)
    end
    def hash
        {"id": @id, "type": self.class.to_s, "name": @name, "position": {"x": @position.x, "y": @position.y}, "data": {"texture": @img_path}}
    end
end