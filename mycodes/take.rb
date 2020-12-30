while count_object_on_map("apple") > 0
    while is_clear_path()
        walk_forward()
        take()
    end
    turn_right()
end
say("I took #{ @robert.inventory.select { |object| object.is_a? GameObjects::Apple }.count } apples...")