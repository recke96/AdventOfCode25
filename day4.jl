import Base.Iterators: map, reduce

function (@main)(args)
    grid = eachline(args[1]) |>
           l -> map(collect, l) |>
                l -> map(c -> reduce(hcat, c), l) |>
                     l -> reduce(vcat, l)

    accessible_rolls = 0
    for col = axes(grid, 2), row = axes(grid, 1)
        if grid[row, col] == '.'
            continue
        end

        adjecent_rolls = (get(grid, (row + dr, col + dc), '.') for dr in -1:1, dc in -1:1 if (dr != 0 || dc != 0)) |>
                         n -> count(c -> c == '@', n)

        if adjecent_rolls < 4
            accessible_rolls += 1
        end
    end

    @info "Accessible rolls: $(accessible_rolls)"
end