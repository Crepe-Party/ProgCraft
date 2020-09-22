class Map
    attr_accessor :name, :player_spawn, :player_inventory, :elements
    def initialize

    end
    def load map
        @name = map['name']
        @player_spawn = Vector2.new(map['player_spawn']['position']['x'], map['player_spawn']['position']['y'])
        map['player_spawn']['inventory'].each |item|
            puts item
        end
    # Object.const_get('ExampleClass')
    end
end