require_relative './tools/vector'
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
            element = item['object']['type'].camelize.constantize.new
            @elements << element
        end
        puts @elements
    end
end