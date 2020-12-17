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
    casted_text = text.to_s
    puts "Say:|| #{casted_text}"
    @root.whats_arbre.push_message(casted_text)
end
def detection
    return false
end

def strict_to_f(val)
    begin
        val = Float(val)
    rescue => exception
        return nil
    end
    val
end