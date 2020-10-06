require 'gosu'
require_relative 'elements/main_ui'
require_relative '../../events/events_manager'
class FileSelector < Gosu::Window
    attr_reader :keys_down, :ready_for_constraints
    def initialize
        #window
        super 900, 500, {resizable: true}
        self.caption = "ProgCraft - The File Selector 🤔"
        #init
        @keys_down = [] #allowing for sub-frame key press
        @events_manager = EventsManager.new self
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
        @events_manager.update
        #res change
        if @current_window_width != self.width || @current_window_height != self.height
            puts "resolution changed! #{self.width} #{self.height}"
            @current_window_width, @current_window_height = self.width, self.height
            @main_ui.apply_constraints
        end
        @main_ui.update delta_time
    end
    def draw
        # final draw
        elements_to_draw = @main_ui.render.flatten
        elements_to_draw.each{|drawable| drawable.draw_with_clipping}
    end
    def apply_constraints
        return unless @ready_for_constraints
        #start applying constraints to children
        @main_ui.apply_constraints
    end
    def add_event element, type, options = {}, &handler
        @events_manager.add_event(element, type, options, handler)
    end
    def needs_cursor?
        true
    end
    def button_down id
        @keys_down.push id
        @events_manager.update
    end
    def button_up id
        @keys_down -= [id]
        @events_manager.update
    end
end
FileSelector.new