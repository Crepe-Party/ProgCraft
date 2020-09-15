while !detection()
    answer = ask("do you want take axe?")
    return if answer != "oui"
    take
    while is_clear_path()
        walk_forward()
    end
    interact
    drop
end