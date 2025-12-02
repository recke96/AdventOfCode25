import Logging

function (@main)(args)
    t = eachcommadelimitedvalue(args[1]) |>
        v -> Iterators.map(x -> split(x, '-', limit=2), v) |>
        v -> Iterators.map(x -> parse.(Int, x), v) |>
        v -> Iterators.flatmap(x -> x[1]:x[2], v) |>
        v -> Iterators.filter(is_invalid_pt1, v) |>
       #v -> Iterators.filter(is_invalid_pt2, v) |>
        v -> Base.sum(v; init=0)

    @info "Sum of invalid ids: $(t)"
end

function is_invalid_pt1(num::Int)::Bool
    str_num = string(num)
    length(str_num) % 2 != 0 && return false
    stop = length(str_num) ÷ 2
    pattern = @view str_num[1:stop]
    return matches_pattern(pattern, str_num)
end

function is_invalid_pt2(num::Int)::Bool
    num_str = string(num)
    len = length(num_str)
    pattern_lenghts = range(len ÷ 2, 1; step=-1)
    @debug "pattern length $(pattern_lenghts) for number $(num)"
    for pattern_len in pattern_lenghts
        len % pattern_len != 0 && continue
        pattern = @view num_str[1:pattern_len]
        matches_pattern(pattern, num_str) && return true
    end

    return false
end

function matches_pattern(pattern::AbstractString, string::AbstractString)::Bool
    for start in range(length(pattern) + 1, length(string); step=length(pattern))
        stop = start + length(pattern) - 1
        stop > length(string) && return false
        segment = @view string[start:stop]
        @debug "Comparing pattern $(pattern) to segment $(segment) at position $(start)"
        if segment != pattern
            return false
        end
    end
    @debug "Pattern $(pattern) matches string $(string)"
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