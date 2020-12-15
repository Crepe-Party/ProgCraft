require_relative './tools/vector'
Dir[__dir__+'/game_objects/*'].each { |file|
    require_relative file
}
class Map
    attr_accessor :name, :size, :robert_spawn, :robert_inventory, :game_objects
    def initialize
        @name = ''
        @size = Vector2.new(10, 10)
        @robert_spawn = Vector2.new
        @robert_inventory = Array.new
        @game_objects = Array.new
    end
    def load map
        @name = map['name']
        @size.x = map['size']['x']
        @size.y = map['size']['y']
        @robert_spawn.x = map['robert']['position']['x']
        @robert_spawn.y = map['robert']['position']['y']
        map['robert']['inventory'].each do |item|
            object = Object.const_get(item['type']).new
            @robert_inventory << object
        end
        map['elements'].each do |item|
            class_GameObject = Object.const_get(item['type'])
            game_object = class_GameObject.new(id: item['id'], name: item['name'], img_path: item.dig('data','texture'), position: Vector2.new(item['position']['x'], item['position']['y']))
            @game_objects << game_object
        end
    end
    # return content at position, return wall when out of range
    def element_at target_pos
        return GameObjects::Wall.new if target_pos.x < 0 || target_pos.y < 0 || target_pos.x >= size.x || target_pos.y >= size.x
        return game_objects.select {|object| object.position == target_pos}
    end
    def hash
        inventory = []
        @robert_inventory.each do |item|
            inventory << item.hash
        end
        robert = {"position":{"x": @robert_spawn.x, "y": @robert_spawn.y}, "inventory": inventory}
        elements = []
        @game_objects.each do |game_object|
            elements << game_object.hash
        end
        {"name": @name, "robert": robert, "elements": elements, "size": size.to_hash}
    end
end