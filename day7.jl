function (@main)(args)
    splits = @timed pt2(args[1])

    @info "Splits: $(splits.value)"
    @info "Stats: $(splits)"
end

function pt1(file::AbstractString)::Int
    tachyons = Set{Int}()
    splits = 0
    for line in eachline(file)
        if isempty(tachyons)
            start = findfirst('S', line)

            @debug "Start position: $start"
            @debug line

            push!(tachyons, start)
            continue
        end

        next_tachyons = Set{Int}()
        for t in tachyons
            if line[t] == '^'
                splits += 1
                push!(next_tachyons, t - 1)
                push!(next_tachyons, t + 1)
            else
                push!(next_tachyons, t)
            end
        end

        @debug replace_chars(line, '|', next_tachyons)

        tachyons = next_tachyons
    end

    return splits
end

function replace_chars(str::AbstractString, char::Char, indices)
    str_array = collect(str)
    for i in indices
        str_array[i] = char
    end
    return String(str_array)
end

function pt2(file::AbstractString)::Int
    graph = read_graph(file)
    discovered::Vector{Node} = copy(graph.out)
    visited::Set{Tuple{Int,Int}} = Set{Tuple{Int,Int}}()
    timelines::Dict{Tuple{Int,Int},Int} = Dict(graph.id => 1)
    total_timelines::Int = 0
    while !isempty(discovered)
        current = popfirst!(discovered)
        if current.id in visited
            continue
        end

        current_timelines = sum(timelines[parent.id] for parent in current.in)

        @debug "Node $(current.id) is reachable in $current_timelines ways."

        timelines[current.id] = current_timelines
        if isempty(current.out)
            # we count all possible ways to reach a leaf node
            total_timelines += current_timelines

            @debug "Node $(current.id) is a leaf node. Total timelines is now $total_timelines"
        end

        push!(visited, current.id)
        for child in current.out
            # to remain in topological order (line number (id[1]) is a natural topological order here)
            insert_sorted!(discovered, child)
        end
    end

    return total_timelines
end

struct Node
    id::Tuple{Int,Int}
    in::Vector{Node}
    out::Vector{Node}
end

function read_graph(file::AbstractString)::Node
    graph::Node = Node((0, 0), [], [])
    last_nodes::Vector{Node} = []
    for (line_num, line) in enumerate(eachline(file))
        if isempty(last_nodes)
            start = findfirst('S', line)
            graph = Node((line_num, start), [], [])
            last_nodes = [graph]
            continue
        end

        if all((!=)('^'), line)
            continue
        end

        next_nodes = []
        for n in last_nodes
            t = n.id[2]
            if line[t] == '^'
                left_idx = (line_num, t - 1)
                right_idx = (line_num, t + 1)

                left_next = findfirst(n -> n.id == left_idx, next_nodes)
                right_next = findfirst(n -> n.id == right_idx, next_nodes)

                left = isnothing(left_next) ? Node(left_idx, [], []) : next_nodes[left_next]
                right = isnothing(right_next) ? Node(right_idx, [], []) : next_nodes[right_next]

                push!(n.out, left, right)
                push!(left.in, n)
                push!(right.in, n)

                if isnothing(left_next)
                    push!(next_nodes, left)
                end
                if isnothing(right_next)
                    push!(next_nodes, right)
                end
            else
                push!(next_nodes, n)
            end
        end

        last_nodes = next_nodes
    end

    return graph
end

function Base.show(io::IO, n::Node)
    print(io, n.id, "\n\t in: ", getfield.(n.in, :id), "\n\tout: ", getfield.(n.out, :id))
end

function insert_sorted!(vec::Vector{Node}, node::Node)
    for i in eachindex(vec)
        if node.id[1] < vec[i].id[1]
            insert!(vec, i, node)
            return
        end
    end
    push!(vec, node)
end