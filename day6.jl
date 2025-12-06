
function (@main)(args)
    grand_total = @timed pt2(args[1])

    @info "Grand Total: $(grand_total.value)"
    @info "Stats: $(grand_total)"
end

function pt1(file::AbstractString)::Int
    operators = missing
    subtotals = missing
    for line in readlines(file) |> Iterators.reverse
        columns = split(line)
        @debug "Processing '$(line)'"
        @debug "Split into $(length(columns)) columns"

        if ismissing(operators)
            operators = columns |> c -> map(o -> o == "+" ? (+) : (*), c)
            continue
        end

        values = parse.(Int, columns)
        if ismissing(subtotals)
            subtotals = values
            continue
        end

        subtotals = broadcast((op, a, b) -> op(a, b), operators, values, subtotals)
    end
    return sum(subtotals)
end

function pt2(file::AbstractString)::Int
    lines = readlines(file)
    operators_line = pop!(lines)

    grid = lines |>
           l -> map(c -> reduce(hcat, c), l) |>
                l -> reduce(vcat, l)

    columns = find_columns(grid)
    operators = map(o -> o == "+" ? (+) : (*), split(operators_line))

    total = 0
    for op in operators
        column = popfirst!(columns)
        subtotal = reduce(op, column)
        total += subtotal
    end

    return total
end

function find_columns(lines::Matrix{Char})::Vector{Vector{Int}}
    columns = Vector{Vector{Int}}()
    current = Vector{Int}()
    for col in axes(lines, 2)
        if all(lines[:, col] .== ' ')
            push!(columns, current)
            current = Vector{Int}()
            continue
        end

        value = parse(Int, String(lines[:, col]))
        push!(current, value)
    end

    push!(columns, current)
    return columns
end