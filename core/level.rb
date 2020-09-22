require_relative './tools/file_manager'
require_relative './map'
class Level
    attr_accessor :name, :objectives, :maps
    attr :level
    def initialize
        @maps = Array.new
        @objectives = Array.new
        @name = ''
    end
    def load path
        @level = File_manager.instance.read_level_file path
        exit if level.nil?
        @name = @level['name']
        @level['maps'].each do |map|
            nmap = Map.new
            nmap.load(map)
            @maps << nmap
        end
    end
    def save path
        
    end
end