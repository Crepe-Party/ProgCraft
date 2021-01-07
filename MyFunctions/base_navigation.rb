# navigation functions
def gps_x
    mark_instruction 
    @robert.position.x
end 
def gps_y
    mark_instruction   
    @robert.position.y
end
def is_clear_path
    mark_instruction
    @robert.is_clear_path
end
def is_clear_right
    mark_instruction
    @robert.is_clear_right
end
def is_clear_left
    mark_instruction    
    @robert.is_clear_left
end
def walk_forward
    start_instruction
    puts "walk forward"
    @robert.move_forward{ finish_instruction }
    wait_for_clearance
end
def turn_right
    start_instruction
    puts "turn right"
    @robert.turn(:right){ finish_instruction }
    wait_for_clearance
end
def turn_left
    start_instruction
    puts "turn left"
    @robert.turn(:left){ finish_instruction }
    wait_for_clearance
end
def turn_back
    start_instruction
    puts "turn back"
    @robert.turn(:behind){ finish_instruction }
    wait_for_clearance
end

def compass
    mark_instruction
    return case @robert.look_at
    when :up then "north"
    when :down then "south"
    when :left then "west"
    when :right then "east"
    end
end