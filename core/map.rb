require_relative './tools/vector'
Dir[__dir__+'/game_objects/*'].each { |file|
    require_relative file
}
class Map
    attr_accessor :name, :player_spawn, :player_inventory, :elements
    def initialize
        @name = ''
        @player_spawn = Vector2.new(0,0)
        @player_inventory = Array.new
        @elements = Array.new
    end
    def load map
        @name = map['name']
        @player_spawn.x = map['robert']['position']['x']
        @player_spawn.y = map['robert']['position']['y']
        map['robert']['inventory'].each do |item|
            object = GameObjects.const_get(item['object']['type'].capitalize).new
            @player_inventory << object
        end
        map['elements'].each do |item|
            class_GameObject = GameObjects.const_get(item['type'].capitalize)
            element = class_GameObject.new item['id'], item['name'], __dir__+'/assets/'+item['data']['texture'], Vector2.new(item['position']['x'], item['position']['y'])
            @elements << element
        end
    end
    def render
        @elements.each do |element|
            element.draw
        end
    end
end