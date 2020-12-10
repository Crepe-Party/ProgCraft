# interaction functions
def ask text
    say text
    puts "Ask:|| #{text}"
    "a"
end
def say text
    puts "Say:|| #{text}"
    @root.whats_arbre.push_message(text)
end
def detection
    return false
end