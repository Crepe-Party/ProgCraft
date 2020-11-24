class Config
    def initialize
        @base_path = defined?(Ocra) ? File.dirname(ENV["OCRA_EXECUTABLE"]) : File.dirname(__FILE__)
    end
    def assets_dir
        return File.join(@base_path, "assets")
    end
    def my_codes_dir
        return File.join(@base_path, "../mycodes")
    end
    def my_functions_dir
        return File.join(@base_path, "../MyFunctions")
    end
    def my_maps_dir
        return File.join(@base_path, "../MyMaps")
    end
end