# interaction functions
def ask(text, indirect_call: false)
    mark_instruction unless indirect_call
    say(text, indirect_call: true)
    answer = nil
    @root.whats_arbre.on_answer do |response|
        answer = response
    end
    sleep 0.1 until answer

    answer
end
def ask_number(text, indirect_call: false)
    mark_instruction unless indirect_call
    val = nil
    loop do
        next say("Not a number!", indirect_call: true) unless val = strict_to_f(ask(text, indirect_call: true))
        break
    end
    i_val = val.to_i
    val = i_val if val == i_val

    val
end
def say(text, indirect_call: false)
    @robert.say text
    mark_instruction unless indirect_call
end
def detection
    mark_instruction
    result = @robert.on_an_object
    result ? result.class.pretty_s : nil
end
def take
    @robert.take if @robert.on_an_object
    mark_instruction
end
def give object_name, quantity = 1
    game_object_name = GameObjects.constants.find { |c| GameObjects.const_get(c).is_a?(Class) && GameObjects.const_get(c).pretty_s.downcase == object_name.downcase }
    
    start_instruction
    @root.plan_action do
        object_class = GameObjects.const_get(game_object_name)
        @robert.give object_class.new, quantity
        finish_instruction
    end
    wait_for_clearance
end
def drop    
    @root.plan_action do
        game_object = @robert.drop
        @root.level.maps[0].add_object(game_object) if game_object
    end
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
    @root.level.maps[0].game_objects.select { |gameObject| gameObject.class.pretty_s.downcase == object_name.downcase }.count
end