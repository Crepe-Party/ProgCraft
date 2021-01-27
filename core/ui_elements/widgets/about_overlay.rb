require_relative 'scrollable'
class AboutOverlay < UIElement
    def build
        super
        @position_progress = 1
        @sub_elements[:button] = Button.new(@root, "About", bg_color: Gosu::Color::rgba(255,255,255,128))
        .constrain{Rectangle2.new(5,@rectangle.bottom-25,100,20)}
        .on_click do 
            @current_transition&.cancel
            @about_shown = !(@about_shown || false)
            @root.animate(0.5, from: @position_progress, to: @about_shown?0:1, timing_function: :ease,
                on_progression: ->(progress) do
                    @sub_elements[:text_section].should_render = true
                    @position_progress = progress
                    self.apply_constraints
                end,
                on_finish: ->do
                    return if @about_shown 
                    @sub_elements[:text_section].should_render = false
                end
            )
        end

        @sub_elements[:text_section] = TextSection.new(@root)
        .constrain{@rectangle.relative_to(x:50,y:50 - @rectangle.height*@position_progress,width:-100,height:-100)}
        @sub_elements[:text_section].should_render = false
    end
    class TextSection < Scrollable
        def build
            self.background_color = Gosu::Color::rgba(0,0,0,220)

            @sub_elements[:main_title] = Text.new(@root, "ProgCraft", font_size: 40, color: Gosu::Color::WHITE, center_text: false)
            .constrain{|el| @scrl_rect.relative_to(x:20, y:20, width: -40).assign!(height: el.text_height)}
            
            what_is_string = "ProgCraft is a software designed to replace the outdated \"PacMan Prog\" at teaching programming to beginners"
            @sub_elements[:what_is] = Text.new(@root, what_is_string, color: Gosu::Color::WHITE, break_lines: true, center_text: false)
            .constrain{|el| r=@sub_elements[:main_title].rectangle; r.assign(y:r.bottom + 5, height: el.text_height)}
    
            who_string = "It was (initially) developped by the 2nd year ES Techs (dev) students for a project. \r\n" + 
            "\"Crepe-Party\" Team: \r\n    - Nicolas Maitre\r\n    - Diogo Vieira Ferreira\r\n    - Florian Bergmann"
            @sub_elements[:who_is] = Text.new(@root, who_string, color: Gosu::Color::WHITE, break_lines: true, center_text: false)
            .constrain{|el| r=@sub_elements[:what_is].rectangle; r.assign(y:r.bottom + 5, height: el.text_height)}
    
            kind_words = "We hope that you will enjoy using it as much as we did making it!"
            @sub_elements[:kind_words] = Text.new(@root, kind_words, font_size: 25, color: Gosu::Color::WHITE, break_lines: true, center_text: false)
            .constrain{|el| r=@sub_elements[:who_is].rectangle; r.assign(y:r.bottom + 5, height: el.text_height)}
    
            @sub_elements[:line] = Rectangle.new(@root, Gosu::Color::GRAY)
            .constrain{r=@sub_elements[:kind_words].rectangle; r.assign(y:r.bottom + 20,height:2)}
    
            liscenses_string = Gosu::LICENSES + "FXRuby, https://github.com/larskanis/fxruby, GNU LGPL 2, https://www.gnu.org/licenses/old-licenses/lgpl-2.0.html"
            @sub_elements[:legal] = Text.new(@root, liscenses_string, font_size: 18, color: Gosu::Color::WHITE, break_lines: true, center_text: false)
            .constrain{|el| r=@sub_elements[:line].rectangle; r.assign(y:r.bottom + 10, height: el.text_height + 10)}    
            
            @sub_elements[:heart] = Text.new(@root, "<3", color: Gosu::Color::WHITE)
            .constrain{rect = @rectangle; Rectangle2.new(rect.right - 20, rect.bottom - 15)}
            @no_scroll_elements << :heart

            super
        end
    end
end