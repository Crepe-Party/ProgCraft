require 'gosu'
require_relative 'ui_elements/main_ui'
class FileSelector < Gosu::Window
    attr_reader :keys_down, :ready_for_constraints
    def initialize
        @keys_down = [] #allowing for sub-frame key press
        #window
        super 900, 500, {resizable: true}
        self.caption = "The File Selector 🤔"
        #build
        @ready_for_constraints = false
        @main_ui = FileSelectorUI::MainUI.new(self){Rectangle2.new(0,0,self.width,self.height)}
        @ready_for_constraints = true
        #show
        self.show
    end
    def update
        #time
        time = Time.now.to_f
        delta_time = time - (@last_time || time)
        @last_time = time
        #res change
        if @current_window_width != self.width || @current_window_height != self.height
            puts "resolution changed! #{self.width} #{self.height}"
            @current_window_width, @current_window_height = self.width, self.height
            @main_ui.apply_constraints
        end
        @main_ui.update delta_time
    end
    def draw
        @main_ui.render
    end
    def needs_cursor?
        true
    end
    def button_down id
        @keys_down.push id
        @editor.events_manager.update
    end
    def button_up id
        @keys_down -= [id]
        @editor.events_manager.update
    end
end
FileSelector.new