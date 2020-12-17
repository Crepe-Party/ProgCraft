# navigation functions
def gps_x
    @robert.position.x
end 
def gps_y
    @robert.position.x
end
def is_clear_path
    wait_for_clearance
    instruction_finished
    @robert.is_clear_path
end
def is_clear_right
    wait_for_clearance
    instruction_finished
    return true #TODO
end
def is_clear_left
    wait_for_clearance
    instruction_finished    
    return true #TODO
end
def walk_forward
    wait_for_clearance
    puts "walk forward"
    @robert.move_forward{self.instruction_finished}
end
def turn_right
    wait_for_clearance
    puts "turn right"
    @robert.turn_right{self.instruction_finished}
end
def turn_left
    wait_for_clearance
    puts "turn left"
    @robert.turn_left{self.instruction_finished}
end