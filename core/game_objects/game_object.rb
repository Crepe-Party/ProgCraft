require_relative '../tools/vector'
require_relative '../config'
class GameObject
    attr :id, :name, :texture, :img_path, :file_path
    attr_accessor :position
    def self.default_texture
        'nothing_64x.png'
    end
    def initialize(id: nil, name: nil, img_path: nil, position: Vector2.new(0, 0))
        file_path = File.join(Config::ASSETS_DIR, img_path || self.class.default_texture)
        @id, @name, @texture, @position, @img_path = id, name, Gosu::Image.new(file_path), position, img_path
    end 
    def draw x = @position.x, y = @position.y
        @texture.draw(x, y, 0)
    end
    def hash
        hash = {"type": self.class.to_s, "position": {"x": @position.x, "y": @position.y}}
        hash["id"] = @id if @id
        hash["name"] = @name if @name
        hash["data"] = {"texture": @img_path} if @img_path
        hash
    end
    def solid?
        false
    end
    def self.pretty_s
        self.to_s.split('::').last
    end
end