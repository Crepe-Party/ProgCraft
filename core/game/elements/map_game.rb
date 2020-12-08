require_relative '../../ui_elements/widgets/grid_game_container'
require_relative './whats_arbre'
class MapGameDisplay < GridGameContainer
    attr_reader :whats_arbre_open
    WA_MARGIN = 20
    WA_BTN_SIZE = 80
    WA_WIDTH = 400
    def build
        @whats_arbre_open = false
        @whats_arbre_top_fraction = 1
        self.background_color = Gosu::Color::rgba(0,200,0,255)
        @sub_elements[:whats_arbre] = WhatsArbre.new(@root).constrain do 
            top_pos = @whats_arbre_top_fraction * (@rectangle.height - WA_MARGIN)
            @rectangle.relative_to(x: @rectangle.width - WA_WIDTH - WA_MARGIN, y: WA_MARGIN + top_pos, height: - 3*WA_MARGIN - WA_BTN_SIZE).assign!(width: WA_WIDTH)
        end
        @sub_elements[:whats_arbre_button] = Button.new(@root, background_image: 'icons/whatsapp_logo_64x.png', bg_color: Gosu::Color::rgba(255,255,255,128))
            .constrain{ Rectangle2.new(@rectangle.right - WA_BTN_SIZE - WA_MARGIN, @rectangle.bottom - WA_BTN_SIZE - WA_MARGIN, WA_BTN_SIZE, WA_BTN_SIZE) }
            .on_click{ self.whats_arbre_open^=true }
        super
    end
    def whats_arbre_open= is_open
        return is_open if @whats_arbre_open == is_open
        @whats_arbre_open = is_open
        #animate
        @current_open_animation.cancel if @current_open_animation
        from_fract = @whats_arbre_top_fraction
        to_fract = is_open ? 0 : 1
        @current_open_animation = @root.animate(0.5) do |progression|
            smooth = Transition.smooth_progression(progression)
            @whats_arbre_top_fraction = (to_fract - from_fract) * smooth + from_fract
            @sub_elements[:whats_arbre].apply_constraints
        end
    end
end