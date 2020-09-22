require 'singleton'
require 'json'
class File_manager
    include Singleton
    def read_level_file path_file
        return File.exist?(path_file) ? JSON.parse(File.read(path_file)) : nil
    end
end