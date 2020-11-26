require 'singleton'
require 'json'
module File_manager
    def self.read_json path_file
        return File.exist?(path_file) ? JSON.parse(File.read(path_file)) : nil
    end
    def self.write_json path_file, json
        File.open(path_file,"w") do |file|
            file.write(json.to_json)
        end
    end
    def self.read path_file
        return File.exist?(path_file) ? File.read(path_file) : nil
    end
end