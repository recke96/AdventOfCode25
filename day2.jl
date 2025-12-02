import Logging

(@main)(args) = open(args[1], "r") do io
    invalid_ticket_id_sum = 0
    while (range = readuntil(io, ',')) != ""
        min_str, max_str = split(range, '-', limit=2)
        min = parse(Int, min_str)
        max = parse(Int, max_str)

        
        invalid_ticket_id_sum += filter(is_repeated_number, Base.range(min, max)) |> sum
    end
    @info "Sum of invalid ticket IDs: $(invalid_ticket_id_sum)"
end

function is_repeated_number(num::Int)::Bool
    str_num = string(num)
    if length(str_num) % 2 != 0
        return false
    end
    stop = length(str_num) ÷ 2
    for i in 1:stop
        if str_num[i] != str_num[stop + i]
            return false
        end
    end
    @debug "Found invalid id: $(num)"
    return true
end