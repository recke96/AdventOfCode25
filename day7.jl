function (@main)(args)
    splits = @timed pt1(args[1])

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