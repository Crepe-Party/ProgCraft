require_relative './tools/vector'
Dir[__dir__+'/game_objects/*'].each { |file|
    require_relative file
}
class Map
    attr_accessor :name, :size, :robert_spawn, :robert_spawn_direction, :robert_inventory, :game_objects
    def initialize
        @name = ''
        @size = Vector2.new 10, 10
        @robert_spawn = Vector2.new
        @robert_spawn_direction = :right
        @robert_inventory = Array.new
        @game_objects = Array.new
    end
    def add_object object
        @game_objects << object
    end
    def remove_object object
        game_objects.delete object
    end
    def load map
        @name = map['name']
        @size.x = map['size']['x']
        @size.y = map['size']['y']
        @robert_spawn.x = map['robert']['position']['x']
        @robert_spawn.y = map['robert']['position']['y']
        @robert_spawn_direction = map['robert']['direction']&.to_sym || :right
        map['robert']['inventory'].each do |item|            
            game_object = Object.const_get(item['type']).new(id: item['id'], name: item['name'], img_path: item.dig('data','texture'))
            @robert_inventory << game_object
        end
        map['elements'].each do |item|
            class_GameObject = Object.const_get(item['type'])
            game_object = class_GameObject.new(id: item['id'], name: item['name'], img_path: item.dig('data','texture'), position: Vector2.new(item['position']['x'], item['position']['y']))
            @game_objects << game_object            
        end
    end
    # return content at position, return wall when out of range
    def element_at target_pos
        return GameObjects::Wall.new if target_pos.x < 0 || target_pos.y < 0 || target_pos.x >= size.x || target_pos.y >= size.y
        return game_objects.find{ |object| object.position == target_pos }
    end
    def to_hash
        {
            name: @name, 
            robert: {
                position: @robert_spawn.to_hash,
                direction: @robert_spawn_direction, 
                inventory: @robert_inventory.map(&:to_hash)
            }, 
            elements: @game_objects.map(&:to_hash), 
            size: size.to_hash
        }
    end
end