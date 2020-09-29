require 'singleton'
require 'json'
module File_manager
    def self.read_level_file path_file
        return File.exist?(path_file) ? JSON.parse(File.read(path_file)) : nil
    end
    def self.write_level_file path_file, json
        File.open(path_file,"w") do |file|
            file.write(json.to_json)
        end
    end
end