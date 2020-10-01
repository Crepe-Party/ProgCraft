require_relative './tools/vector'
Dir[__dir__+'/game_objects/*'].each { |file|
    require_relative file
}
class Map
    attr_accessor :name, :robert_spawn, :robert_inventory, :elements
    def initialize
        @name = ''
        @robert_spawn = Vector2.new(0,0)
        @robert_inventory = Array.new
        @elements = Array.new
    end
    def load map
        @name = map['name']
        @robert_spawn.x = map['robert']['position']['x']
        @robert_spawn.y = map['robert']['position']['y']
        map['robert']['inventory'].each do |item|
            object = Object.const_get(item['type']).new
            @robert_inventory << object
        end
        map['elements'].each do |item|
            class_GameObject = Object.const_get(item['type'])
            element = class_GameObject.new item['id'], item['name'], item['data']['texture'], Vector2.new(item['position']['x'], item['position']['y'])
            @elements << element
        end
    end
    def hash
        inventory = []
        @robert_inventory.each do |item|
            inventory << item.hash
        end
        robert = {"position":{"x": @robert_spawn.x, "y": @robert_spawn.y}, "inventory": inventory}
        elements = []
        @elements.each do |element|
            elements << element.hash
        end
        {"name": @name, "robert": robert, "elements": elements}
    end
    def render
        @elements.each(&:draw)
    end
end