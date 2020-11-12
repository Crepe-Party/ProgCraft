require 'fox16'
include Fox

class WindowManager
    def initialize
        theApp = FXApp.new 
        @theMainWindow = FXMainWindow.new(theApp, "Hello")
        theApp.create
    end

    def open_file initial_dir: "/", title: "Open file", patterns: ["All Files (*)"], preferred_file_filter: 0
        openDialog = FXFileDialog.new(@theMainWindow, title)
        openDialog.directory = initial_dir
        openDialog.patternList = patterns
        openDialog.currentPattern = preferred_file_filter
        file = ""
        if openDialog.execute != 0
            @preferred_file_filter = openDialog.currentPattern
            file = openDialog.filename
        end
        file
    end

    def save_file initial_dir: "/", title: "Save a ProgCraft map", filename: Time.now.strftime("%Y-%m-%d"), default_extension: 'json', patterns: ["All Files (*)"], preferred_file_filter: 0
        saveDialog = FXFileDialog.new(@theMainWindow, title)
        saveDialog.directory = initial_dir
        saveDialog.patternList = patterns
        saveDialog.currentPattern = @preferred_file_filter || preferred_file_filter
        file = ""
        if saveDialog.execute != 0
            if File.exist? saveDialog.filename
                if MBOX_CLICKED_NO == FXMessageBox.question(@theMainWindow, MBOX_YES_NO,
                    "Overwrite file", "Overwrite existing file?")
                    return ""
                end
            end            
            file = saveDialog.filename
        end
        return file == "" ? "" : File.extname(file) == "" ? "#{file}.#{default_extension}" : file
    end
end