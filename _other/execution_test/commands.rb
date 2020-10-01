def move_forward
    execution.wait_for_clearance

    x, y = game.robert.rectangle.position.to_a
    y -= 1 if game.robert.direction == :up
    y += 1 if game.robert.direction == :down
    x -= 1 if game.robert.direction == :left
    x += 1 if game.robert.direction == :right

    game.robert.move_to(x, y){execution.instruction_finished}
end
def turn_right
    execution.wait_for_clearance

    new_direction = case game.robert.direction
    when :up then :right
    when :right then :down
    when :down then :left
    when :left then :up
    end

    game.robert.rotate_to(new_direction, clockwise: true){execution.instruction_finished}
end
def turn_left
    execution.wait_for_clearance

    new_direction = case game.robert.direction
    when :up then :left
    when :right then :up
    when :down then :right
    when :left then :down
    end

    game.robert.rotate_to(new_direction, clockwise: false){execution.instruction_finished}
end