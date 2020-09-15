pos_x = gps_x()
pos_y = gps_y()
step_counter = 0

while pos_x != 2 and pos_y != 6
    if is_clear_path()
        move_forward()
        step_counter += 1
    elsif is_clear_right()
        turn_right()
    elsif is_clear_left()
        turn_left()
    else
        turn_back()
    end
end

def turn_back()
    turn_left()
    turn_left()
end