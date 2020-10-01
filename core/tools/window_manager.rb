require 'thread'
class WindowManager
    def initialize
        @threadeuh = Thread.new { require 'tk' }
    end
    def open_file initialdir, title: "Select Files", multiple: false, default_extension: 'json', filetypes: "{{ProgCraft map} {.json}}"
        Thread.new do
            @threadeuh.join
            yield Tk.getOpenFile(  'title' => title,
                'multiple' => multiple, 
                'defaultextension' => default_extension,
                'initialdir' => initialdir,
                'filetypes' => filetypes)
        end
    end
    def save_file initialdir, title: "Save a ProgCraft map", initialfile: Time.now.strftime("%Y-%m-%d"), default_extension: 'json', filetypes: "{{ProgCraft map} {.json}}"
        Thread.new do
            @threadeuh.join
            yield Tk.getSaveFile( 'title' => title,
                'defaultextension' => default_extension,
                'initialfile' => initialfile,
                'initialdir' => initialdir,
                'filetypes' => filetypes)
        end
    end
end