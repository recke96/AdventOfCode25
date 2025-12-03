import Logging

function (@main)(args)
    total_joltage = eachline(args[1]) |>
    l -> Iterators.map(find_max_joltage, l) |>
    sum

    @info "Total joltage: $(total_joltage)"
end

function find_max_joltage(bank::AbstractString)::Int
   active = (bank[1], bank[2])
   for i in Iterators.drop(eachindex(bank), 2)
       if bank[i-1] > active[1]
           active = (bank[i-1], bank[i])
       end
       if bank[i] > active[2]
           active = (active[1], bank[i])
       end
   end

   return parse(Int, active[1] * active[2])
end