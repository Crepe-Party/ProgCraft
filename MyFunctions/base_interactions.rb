# interaction functions
def ask(text, indirect_call: false)
    say(text, indirect_call: true)
    answer = nil
    @root.whats_arbre.on_answer do |response|
        answer = response
    end
    sleep 0.1 until answer

    mark_instruction unless indirect_call
    answer
end
def ask_number(text, indirect_call: false)
    val = nil
    loop do
        next say("Not a number!", indirect_call: true) unless val = strict_to_f(ask(text, indirect_call: true))
        break
    end
    i_val = val.to_i
    val = i_val if val == i_val

    mark_instruction unless indirect_call
    val
end
def say(text, indirect_call: false)
    @robert.say text
    mark_instruction unless indirect_call
end
def detection
    mark_instruction
    @robert.on_an_object
end
def take
    @robert.take if @robert.on_an_object
    mark_instruction
end
def drop
    game_object = @robert.drop
    @root.level.maps[0].add_object(game_object) if game_object
    mark_instruction
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