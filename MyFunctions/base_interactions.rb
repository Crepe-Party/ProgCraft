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
    @robert.say text
end
def detection
    return false
end