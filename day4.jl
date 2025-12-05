import Base.Iterators: map, reduce

function (@main)(args)
    grid = eachline(args[1]) |>
           l -> map(collect, l) |>
                l -> map(c -> reduce(hcat, c), l) |>
                     l -> reduce(vcat, l)

    accessible_rolls = @timed pt2(grid)

    @info "Accessible rolls: $(accessible_rolls.value)"
    @info "Stats: $(accessible_rolls)"
end

function is_accessible(grid::AbstractMatrix{Char}, col::Int, row::Int)::Bool
    adjecent_rolls = (get(grid, (row + dr, col + dc), '.') for dr in -1:1, dc in -1:1 if (dr != 0 || dc != 0)) |>
                     n -> count((==)('@'), n)

    return adjecent_rolls < 4
end

function find_accessible(grid::AbstractMatrix{Char})::AbstractMatrix{Bool}
    accessible_rolls = similar(grid, Bool)
    for col = axes(grid, 2), row = axes(grid, 1)
        if grid[row, col] == '.'
            accessible_rolls[row, col] = false # not a roll at all
            continue
        end

        accessible_rolls[row, col] = is_accessible(grid, col, row)
    end

    return accessible_rolls
end

function pt1(grid::AbstractMatrix{Char})::Int
    accessible_rolls = find_accessible(grid)
    return count(accessible_rolls)
end

function pt2(grid::AbstractMatrix{Char})::Int
    total_rolls = count((==)('@'), grid)
    phase_accessible_rolls = find_accessible(grid)

    while any(phase_accessible_rolls)
        grid[phase_accessible_rolls] .= '.'
        phase_accessible_rolls = find_accessible(grid)
    end

    remaining_rolls = count((==)('@'), grid)
    return total_rolls - remaining_rolls
end