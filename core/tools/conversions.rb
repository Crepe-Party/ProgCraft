def strict_to_f val
    begin
        val = Float(val)
    rescue => exception
        return nil
    end
    val
end