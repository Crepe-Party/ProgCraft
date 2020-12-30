def turn_to(direction)
    if compass() == direction
        message = "You are already heading " + direction
        say(message)
    else
        while compass() != direction
            turn_right
        end
    end
end
turn_to("north")
turn_to("north")