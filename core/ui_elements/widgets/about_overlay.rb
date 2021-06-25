require_relative 'scrollable'
require_relative '../../game/game'
require_relative './ms_grid_rendering'
class AboutOverlay < UIElement
    def build
        super
        @position_progress = 1
        @sub_elements[:button] = Button.new(@root, "About", bg_color: Gosu::Color::rgba(255,255,255,128))
        .constrain{Rectangle2.new(5,@rectangle.bottom-25,100,20)}
        .on_click do 
            show_overlay !(@about_shown || false)
        end

        @sub_elements[:text_section] = TextSection.new(@root, parent_element: self)
        .constrain{@rectangle.relative_to(x:50,y:50 - @rectangle.height*@position_progress,width:-100,height:-100)}
        @sub_elements[:text_section].should_render = false
    end
    def show_overlay should_show
        @current_transition&.cancel
        @about_shown = should_show
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
            
            @no_scroll_elements << :heart
            @sub_elements[:heart] = Button.new(@root, "<3", text_color: Gosu::Color::WHITE, text_color_hover: Gosu::Color::RED, bg_color: Gosu::Color::rgba(0,0,0,0), bg_color_hover: Gosu::Color::rgba(0,0,0,0))
            .constrain{rect = @rectangle; Rectangle2.new(rect.right - 40 - 30, rect.bottom - 30, 30, 30)}
            .on_click{on_layout}

            super
        end

        def on_layout
            @sc = (@sc || 0) + 1
            sz = 25 + 5*@sc
            @sub_elements[:heart].text_elem.font = Gosu::Font.new(sz - 5, name: "Consolas")
            @sub_elements[:heart].constrain{rect = @rectangle; Rectangle2.new(rect.right - 40 - sz, rect.bottom - sz, sz, sz)}
            @sub_elements[:heart].text_elem.color = [Gosu::Color::RED, Gosu::Color::GREEN, Gosu::Color::YELLOW][@sc % 3]
            @sub_elements[:heart].apply_constraints
            #not available in editor
            return unless @root.class == Game
            if(@sc == 5)
                @root.robert.spin
                @root.robert.say "speeeen"
            elsif(@sc == 10)
                @root.robert.spin
                @root.robert.say "again"
            elsif(@sc == 15)
                @root.robert.say "have fun ;)"
                @root.main_ui.sub_elements[:map_game].static = true
                @root.main_ui.sub_elements[:map_game].reset_camera duration: 3
                @root.pause
                self.parent_element.show_overlay false
                @root.robert.spin on_finish: ->do
                    @root.robert.direction = :down
                    @root.robert.state = :stun
                    @root.animate(3,from:  @root.robert.position.y, to: -2, timing_function: :ease_in) do |progress|
                        @root.robert.position.y = progress
                    end
                    @root.robert.spin duration: 3, on_finish: ->do 
                        @root.main_ui.sub_elements[:map_game].whats_arbre_open = false
                        dispatch_render(@root.main_ui.sub_elements[:map_game])
                    end
                end
            end
        end
    end
end