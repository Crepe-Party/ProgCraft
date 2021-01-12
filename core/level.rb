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
        @level = File_manager.read_json path_file
        return if @level.nil?
        @maps.clear
        @name = @level['name']
        @maps = @level['maps'].map { |map| Map.new.load(map) }
    end
    def save path_file
        maps = @maps.map(&:to_hash)
        json = {"name": @name, "maps": maps}
        File_manager.write_json path_file, json
    end
    def render map_number
        @maps[map_number].render
    end
end