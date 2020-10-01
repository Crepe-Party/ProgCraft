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

    game.robert.direction = case game.robert.direction
    when :up then :right
    when :right then :down
    when :down then :left
    when :left then :up
    end
    #animation
    sleep 0.2

    execution.instruction_finished
end