require_relative './tools/vector'
Dir[__dir__+'/game_objects/interactable/*'].each { |file|
    require_relative file
}
class Map
    attr_accessor :name, :player_spawn, :player_inventory, :elements
    def initialize
        @name = ''
        @player_spawn = Vector2.new
        @player_inventory = Array.new
        @elements = Array.new
    end
    def load map
        @name = map['name']
        @player_spawn.x = map['player_spawn']['position']['x']
        @player_spawn.y = map['player_spawn']['position']['y']
        map['player_spawn']['inventory'].each do |item|
            object = Object.const_get(item['object']['type'].capitalize).new
            @player_inventory << object
        end
        map['elements'].each do |item|
            element = Object.const_get(item['type'].capitalize).new
            @elements << element
        end
    end
end