import Logging

function (@main)(args)
    t = eachcommadelimitedvalue(args[1]) |>
        v -> Iterators.map(x -> split(x, '-', limit=2), v) |>
        v -> Iterators.map(x -> parse.(Int, x), v) |>
        v -> Iterators.flatmap(x -> x[1]:x[2], v) |>
        v -> Iterators.filter(is_invalid_pt1, v) |>
        sum

    @info "Sum of invalid pt1 ids: $(t)"
end

function is_invalid_pt1(num::Int)::Bool
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
    @debug "Found invalid pt1 id: $(num)"
    return true
end

function eachcommadelimitedvalue(file::AbstractString)::Channel{String}
    return Channel{String}() do ch
        open(file, "r") do io
            while (value = readuntil(io, ',')) != ""
                put!(ch, value)
            end
        end
    end
end