# navigation functions
def gps_x
    return @robert.position.x
end 
def gps_y
    return @robert.position.x
end
def is_clear_path
    return true
end
def is_clear_right
    return true
end
def is_clear_left
    return true
end
def walk_forward
    wait_for_clearance
    puts "walk forward"
    @robert.move_forward{self.instruction_finished}
end
def turn_right
    wait_for_clearance
    puts "turn right"
    @robert.turn_right
    instruction_finished
end
def turn_left
    puts "turn left"
    wait_for_clearance
    @robert.turn_left
    instruction_finished
end