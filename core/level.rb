require_relative './tools/file_manager'
require_relative './map'
class Level
    attr_accessor :name, :objectives, :maps
    attr :level
    def initialize
        @maps = Array.new
        @maps << Map.new
        @objectives = Array.new
        @name = ''
    end
    def load path_file
        @maps.clear
        @level = File_manager.read_json path_file
        return if level.nil?
        @name = @level['name']
        @level['maps'].each do |map|
            nmap = Map.new
            nmap.load(map)
            @maps << nmap
        end
    end
    def save path_file
        maps = @maps.map(&:hash)
        json = {"name": @name, "maps": maps}
        File_manager.write_json path_file, json
    end
    def render map_number
        @maps[map_number].render
    end
end