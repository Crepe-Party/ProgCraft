require 'fox16'
include Fox

class WindowManager
    def initialize
        fx_app = FXApp.new 
        @fx_main_window = FXMainWindow.new(fx_app, "WindowManager")
        fx_app.create
    end

    def open_file initial_dir: "/", title: "Open file", patterns: ["All Files (*)"], preferred_file_filter: 0
        open_dialog = FXFileDialog.new(@fx_main_window, title)
        open_dialog.directory = initial_dir
        open_dialog.patternList = patterns
        open_dialog.currentPattern = preferred_file_filter
        file = ""
        if open_dialog.execute != 0
            @preferred_file_filter = open_dialog.currentPattern
            file = open_dialog.filename
        end
        file
    end

    def save_file initial_dir: "/", title: "Save a ProgCraft map", filename: Time.now.strftime("%Y-%m-%d"), default_extension: 'json', patterns: ["All Files (*)"], preferred_file_filter: 0
        save_dialog = FXFileDialog.new(@fx_main_window, title)
        save_dialog.directory = initial_dir
        save_dialog.patternList = patterns
        save_dialog.currentPattern = @preferred_file_filter || preferred_file_filter
        file = ""
        if save_dialog.execute != 0
            if File.exist? save_dialog.filename
                if MBOX_CLICKED_NO == FXMessageBox.question(@fx_main_window, MBOX_YES_NO,
                    "Overwrite file", "Overwrite existing file?")
                    return ""
                end
            end            
            file = save_dialog.filename
        end
        return file == "" ? "" : File.extname(file) == "" ? "#{file}.#{default_extension}" : file
    end
end