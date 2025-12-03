import Logging
import Base.Iterators: drop, map

function (@main)(args)
    total_joltage = eachline(args[1]) |>
    l -> map(b -> max_joltage(b, 12), l) |>
    sum

    @info "Total joltage: $(total_joltage)"
end

function max_joltage(bank::AbstractString, active_bats::Int)::Int
    active = collect(bank[1:active_bats])
    for i in drop(eachindex(bank), active_bats)
        for j in eachindex(active)
            bankidx = i - active_bats + j
            if bank[bankidx] > active[j]
                @debug "updating active batteries at positions $(j:active_bats) with bank positions $(bankidx:i)"
                active[j:active_bats] .= collect(bank[bankidx:i])
                break
            end
        end
    end

    active_str = join(active)

    @debug "Max joltage for bank $(bank) with $(active_bats) batteries is $(active_str)"

    return parse(Int, active_str)
end