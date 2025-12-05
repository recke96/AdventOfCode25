
function (@main)(args)
    fresh_count = @timed pt2(args[1])

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

function pt2(input::AbstractString)::Int
    ranges = Vector{UnitRange{Int}}()

    for line in eachline(input)
        if !read_fresh!(ranges, line)
            break
        end
    end

    @info "$(length(ranges)) fresh ranges read"

    fused_ranges = fuse_ranges(ranges)

    return sum(length, fused_ranges)
end

function overlaps(r1::UnitRange{Int}, r2::UnitRange{Int})::Bool
    return first(r1) in r2 || first(r2) in r1
end

function fuse(r1::UnitRange{Int}, r2::UnitRange{Int})::UnitRange{Int}
    return min(first(r1), first(r2)):max(last(r1), last(r2))
end

function fuse_ranges(ranges::Vector{UnitRange{Int}})::Vector{UnitRange{Int}}
    sorted = sort(ranges; by=r -> first(r))
    fused = UnitRange{Int}[]

    while !isempty(sorted)
        elem = popfirst!(sorted)
        (fused_elem, rest) = fuse_element(elem, sorted)
        @debug "Fused $(elem) into $(fused_elem), $(length(rest)) remaining"
        push!(fused, fused_elem)
        sorted = rest
    end

    return fused
end

function fuse_element(base::UnitRange{Int}, ranges::Vector{UnitRange{Int}})::Tuple{UnitRange{Int},Vector{UnitRange{Int}}}
    fused = copy(base)
    unfused = UnitRange{Int}[]
    for r in ranges
        if overlaps(fused, r)
            fused = fuse(fused, r)
        else
            push!(unfused, r)
        end
    end
    return (fused, unfused)
end