class AboutOverlay < UIElement
    def build
        super
        @position_progress = 1
        @sub_elements[:button] = Button.new(@root, "About", bg_color: Gosu::Color::rgba(255,255,255,128))
        .constrain{Rectangle2.new(5,@rectangle.height-25,100,20)}
        .on_click do 
            @current_transition.cancel if @current_transition
            @about_shown = !(@about_shown || false)
            @root.animate(0.5, from: @position_progress, to: @about_shown?0:1, timing_function: :ease) do |progress|
                @position_progress = progress
                apply_constraints
            end
        end

        #popup
        @sub_elements[:background] = Rectangle.new(@root, Gosu::Color::rgba(0,0,0,220))
        .constrain{@rectangle.relative_to(x:50,y:50 - @rectangle.height*@position_progress,width:-100,height:-100)}
        
        @sub_elements[:main_title] = Text.new(@root, "ProgCraft", font_size: 40, color: Gosu::Color::WHITE, center_text: false)
        .constrain{@sub_elements[:background].rectangle.relative_to(x:20, y:20, width: -40)}
        
        what_is_string = "ProgCraft is a software designed to replace the outdated \"PacMan Prog\" at teaching programming to beginners"
        @sub_elements[:what_is] = Text.new(@root, what_is_string, color: Gosu::Color::WHITE, center_text: false)
        .constrain{@sub_elements[:main_title].rectangle.relative_to(y:45)}

        who_string = "It was (initially) developped by the 2nd year ES Techs (dev) students for a project. \r\n" + 
        "\"Crepe-Party\" Team: \r\n    - Nicolas Maitre\r\n    - Diogo Vieira Ferreira\r\n    - Florian Bergmann"
        @sub_elements[:who_is] = Text.new(@root, who_string, color: Gosu::Color::WHITE, center_text: false)
        .constrain{@sub_elements[:what_is].rectangle.relative_to(y:25)}

        kind_words = "We hope that you will enjoy using it as much as we did making it!"
        @sub_elements[:kind_words] = Text.new(@root, kind_words, font_size: 25, color: Gosu::Color::WHITE, center_text: false)
        .constrain{@sub_elements[:who_is].rectangle.relative_to(y:110)}

        @sub_elements[:line] = Rectangle.new(@root, Gosu::Color::GRAY)
        .constrain{@sub_elements[:kind_words].rectangle.relative_to(y:50).assign!(height:2)}

        liscenses_string = Gosu::LICENSES + "FXRuby, https://github.com/larskanis/fxruby, GNU LGPL 3, https://www.gnu.org/licenses/lgpl-3.0.html"
        @sub_elements[:legal] = Text.new(@root, liscenses_string, font_size: 18, color: Gosu::Color::WHITE, center_text: false)
        .constrain{@sub_elements[:line].rectangle.relative_to(y:15)}

        @sub_elements[:heart] = Text.new(@root, "<3", color: Gosu::Color::WHITE)
        .constrain{rect = @sub_elements[:background].rectangle; Rectangle2.new(rect.right - 20, rect.bottom - 15)}
    end
end