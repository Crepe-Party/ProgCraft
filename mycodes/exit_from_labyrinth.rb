
step_counter = 0

def turn_around()
    turn_back()
end

while gps_x() != 2 || gps_y() != 6
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
say("you took " + step_counter.to_s + " steps") # concatenation
say("you took #{step_counter} steps") # interpolation
