require './tools/file_manager'
class Level
    def load path
        dataFile_manager.instance.read_level_file './MyMaps/exemples.json'
    end
end