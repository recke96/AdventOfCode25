import Base.Iterators: map, reduce

function (@main)(args)
    grid = eachline(args[1]) |>
           l -> map(collect, l) |>
                l -> map(c -> reduce(hcat, c), l) |>
                     l -> reduce(vcat, l)

    accessible_rolls = @timed pt1(grid)

    @info "Accessible rolls: $(accessible_rolls.value)"
    @info "Stats: $(accessible_rolls)"
end

function is_accessible(grid::AbstractMatrix{Char}, col::Int, row::Int)::Bool
    adjecent_rolls = (get(grid, (row + dr, col + dc), '.') for dr in -1:1, dc in -1:1 if (dr != 0 || dc != 0)) |>
                     n -> count(c -> c == '@', n)

    return adjecent_rolls < 4
end

function pt1(grid::AbstractMatrix{Char})
    accessible_rolls = 0
    for col = axes(grid, 2), row = axes(grid, 1)
        if grid[row, col] == '.'
            continue
        end

        if is_accessible(grid, col, row)
            accessible_rolls += 1
        end
    end

    return accessible_rolls
end