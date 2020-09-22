
class Event
    attr_reader :type
    def initialize type, element
        @type, @element = type, element
    end
end