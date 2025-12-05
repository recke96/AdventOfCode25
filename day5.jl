
function (@main)(args)
    fresh_count = @timed pt1(args[1])

    @info "Fresh count: $(fresh_count.value)"
    @info "Stats: $(fresh_count)"
end

function read_fresh!(fresh::Vector{UnitRange{Int}}, line::String)::Bool
    if line == ""
        return false
    end

    (start, stop) = parse.(Int, split(line, '-'; limit=2))
    push!(fresh, start:stop)
    return true
end

function pt1(input::AbstractString)::Int
    read_ranges = true
    fresh_ranges = Vector{UnitRange{Int}}()
    fresh_count = 0
    for line in eachline(input)
        if read_ranges
            read_ranges = read_fresh!(fresh_ranges, line)
            continue
        end

        id = parse(Int, line)
        if any(r -> id in r, fresh_ranges)
            fresh_count += 1
        end
    end
    return fresh_count
end