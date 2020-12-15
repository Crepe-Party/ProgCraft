# navigation functions
def gps_x
    wait_for_clearance
    return @robert.position.x
    instruction_finished
end 
def gps_y
    wait_for_clearance
    return @robert.position.x
    instruction_finished
end
def is_clear_path
    wait_for_clearance
    return true
    instruction_finished
end
def is_clear_right
    wait_for_clearance
    return true
    instruction_finished
end
def is_clear_left
    wait_for_clearance
    return true
    instruction_finished
end
def walk_forward
    wait_for_clearance
    @robert.move_forward{self.instruction_finished}
    instruction_finished
end
def turn_right
    wait_for_clearance
    @robert.turn_right
    instruction_finished
end
def turn_left
    wait_for_clearance
    @robert.turn_left
    instruction_finished
end