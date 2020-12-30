# interaction functions
def ask text
    say text
    answer = nil
    @root.whats_arbre.on_answer do |response|
        answer = response
    end
    sleep 0.1 until answer
    answer
end
def ask_number text
    val = nil
    loop do
        next say("Not a number!") unless val = strict_to_f(ask(text))
        break
    end
    val
end
def say text
    @robert.say text
end
def detection    
    wait_for_clearance
    instruction_finished   
    @robert.on_an_object
end
def take
    @robert.take if @robert.on_an_object
end
def drop
    game_object = @robert.drop
    @root.level.maps[0].add_object(game_object) if game_object
end
def strict_to_f val
    begin
        val = Float(val)
    rescue => exception
        return nil
    end
    val
end
def count_object_on_map object_name
    object_class = Object.const_get("GameObjects::#{object_name.downcase.capitalize}")
    @root.level.maps[0].game_objects.select { |gameObject| gameObject.is_a? object_class }.count
end