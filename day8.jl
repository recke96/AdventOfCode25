
function (@main)(args)
    size = @timed pt1(args[1])

    @info "Circuit Size: $(size.value)"
    @info "Stats: $(size)"
end

function pt1(file::AbstractString)::Int
    coordinates = read_coordinates(file)

    pairs = unique_pairs(coordinates)
    order = sortperm(pairs, by=(pair) -> distance(pair...))

    circuits = [Set{Coordinate}([c]) for c in coordinates]
    connections = 1

    for idx in order
        if connections >= 1000
            break
        end
        connections += 1

        a, b = pairs[idx]

        circuit_a_idx = findfirst(c -> a in c, circuits)
        circuit_b_idx = findfirst(c -> b in c, circuits)

        if circuit_a_idx == circuit_b_idx
            @debug "$a and $b are already connected"
            continue
        end

        
        circuit_a = circuits[circuit_a_idx]
        circuit_b = circuits[circuit_b_idx]

        union!(circuit_a, circuit_b)
        deleteat!(circuits, circuit_b_idx)

        @debug "Connected $a and $b, circuit now has size $(length(circuit_a))"
        @debug "Remaining circuits: $(length(circuits))"
    end

    top = Iterators.map(length, circuits) |>
          c -> sort(collect(c), rev=true) |>
               c -> Iterators.take(c, 3) |>
                    collect

    @debug "The largest 3 circuits have $top elements"

    return Iterators.reduce((*), top)
end

const Coordinate = NamedTuple{(:x, :y, :z),Tuple{Int,Int,Int}}

function read_coordinates(file::AbstractString)::Set{Coordinate}
    coords = Set{Coordinate}()
    for line in eachline(file)
        coords_str = split(line, ',', limit=3)
        x, y, z = parse.(Int, coords_str)
        push!(coords, (x=x, y=y, z=z))
    end
    return coords
end

distance(a::Coordinate, b::Coordinate)::Float64 = √((a.x - b.x)^2 + (a.y - b.y)^2 + (a.z - b.z)^2)

function unique_pairs(coordiantes::Set{Coordinate})::Vector{Tuple{Coordinate,Coordinate}}
    pairs = Vector{Tuple{Coordinate,Coordinate}}()
    coord_list = collect(coordiantes)

    for i in eachindex(coord_list)
        for j in i+1:lastindex(coord_list)
            push!(pairs, (coord_list[i], coord_list[j]))
        end
    end

    return pairs
end