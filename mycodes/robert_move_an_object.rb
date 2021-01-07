steps = 0
while !detection()    
    walk_forward()
    steps += 1
end
answer = ask("do you want take object?")
if answer == "yes"
    take()
    #go to tree
    while is_clear_path()
        walk_forward()
    end
    drop()
    say("The object is too heavy... I'll leave it here ☺")
    turn_back()
    
    while is_clear_path    
        walk_forward()
    end
end
say("Good bye")
