require_relative './tools/file_manager'
require_relative 'map'
class Level
    attr_accessor :name, :objectives, :maps
    def initialize
        @maps = Array.new
        @objectives = Array.new
        @name = ''
    end
    def load path
        @level = File_manager.instance.read_level_file path
        if level.nil? exit
        @name = @level['name']
        @level['maps'].each do |map|
            nmap = Map.new
            nmap.load(map)
            @maps << nmap
        end
        # Object.const_get('ExampleClass')
    end
    def save save
        
    end
end