require_relative 'drawable'
class Image < Drawable
    attr_reader :src
    def initialize root, source= nil, &contraint
        super root, &contraint
        self.source = source if source
    end
    def draw
        @image.draw(@rectangle.x, @rectangle.y, 0) if @image
    end
    def source= src
        @source = src
        @image = Gosu::Image.new src
        # pp "new image #{src}", @image
    end
end