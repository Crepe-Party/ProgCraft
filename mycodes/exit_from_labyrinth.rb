pos_x = gps_x()
pos_y = gps_y()
step_counter = 0

while pos_x != 2 and pos_y != 6
    if is_clear_path()
        walk_forward()
        step_counter += 1
    elsif is_clear_right()
        turn_right()
    elsif is_clear_left()
        turn_left()
    else
        turn_around()
    end
end
say("you took "+step_counter+" steps")

def turn_around()
    turn_right()
    turn_right()
end