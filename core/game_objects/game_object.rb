require_relative '../tools/vector'
class GameObject
    attr :id, :name, :texture, :img_path, :file_path
    attr_accessor :position
    def self.default_texture
        'nothing_64x.png'
    end
    def initialize(id: nil, name: nil, img_path: nil, position: Vector2.new(0, 0))
        img_path = self.class.default_texture unless img_path
        file_path = File.expand_path(File.join("..", "assets", img_path), File.dirname(__FILE__))
        @id, @name, @texture, @position, @img_path = id, name, Gosu::Image.new(file_path), position, img_path
    end 
    def draw x=@position.x, y=@position.y
        @texture.draw(x, y, 0)
    end
    def hash
        {"id": @id, "type": self.class.to_s, "name": @name, "position": {"x": @position.x, "y": @position.y}, "data": {"texture": @img_path}}
    end
    def self.to_s
        super.to_s.split('::').last
    end
end