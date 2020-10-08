while !detection()
    answer = ask("do you want take axe?")
    if answer != "oui"
        return 
    end
    take
    #go to tree
    while is_clear_path()
        walk_forward()
    end
    drop
end