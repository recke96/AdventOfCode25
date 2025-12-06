
function (@main)(args)
    grand_total = @timed pt1(args[1])

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