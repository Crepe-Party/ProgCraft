require 'singleton'
require 'json'
module File_manager
    def self.read_level_file path_file
        return File.exist?(path_file) ? JSON.parse(File.read(path_file)) : nil
    end
end