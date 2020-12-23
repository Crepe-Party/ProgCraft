# navigation functions
def gps_x
    wait_for_clearance
    instruction_finished    
    @robert.position.x
end 
def gps_y
    wait_for_clearance
    instruction_finished    
    @robert.position.y
end
def is_clear_path
    wait_for_clearance
    instruction_finished
    @robert.is_clear_path
end
def is_clear_right
    wait_for_clearance
    instruction_finished
    @robert.is_clear_right
end
def is_clear_left
    wait_for_clearance
    instruction_finished    
    @robert.is_clear_left
end
def walk_forward
    wait_for_clearance
    puts "walk forward"
    @robert.move_forward{ self.instruction_finished }
end
def turn_right
    wait_for_clearance
    puts "turn right"
    @robert.turn(:right){ self.instruction_finished }
end
def turn_left
    wait_for_clearance
    puts "turn left"
    @robert.turn(:left){ self.instruction_finished }
end
def turn_back
    wait_for_clearance
    puts "turn back"
    @robert.turn(:behind){ self.instruction_finished }
end