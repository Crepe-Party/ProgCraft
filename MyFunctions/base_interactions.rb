# interaction functions
def ask text
    say text
    puts "Ask:|| #{text}"

    #simulates user input
    sleep 1
    choice = rand(10)
    @root.whats_arbre.push_message(choice, "Player")
    sleep 0.5
    choice
end
def say text
    casted_text = text.to_s
    puts "Say:|| #{casted_text}"
    @root.whats_arbre.push_message(casted_text)
end
def detection
    return false
end