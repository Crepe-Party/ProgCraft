turn_to("north")

def turn_to(direction)
    current_direction = compass()
    if current_direction == direction
        message = "You are already heading "+direction
        say(message)
    else
        while current_direction != direction
            turn_right
        end
    end
end