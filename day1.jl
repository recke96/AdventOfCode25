import Logging

function (@main)(args)
    lines = eachline(args[1])
    #pt1(lines)
    pt2(lines)
end

function pt1(lines::Base.EachLine)
    dial::Int = 50;
    dial_zero_count::Int = 0
    
    for instruction in lines
        dial, _ = apply_instruction(dial, instruction)

        if dial == 0
            dial_zero_count += 1
        end
    end

    @info "Dial was zero $(dial_zero_count) times"
end

function pt2(lines::Base.EachLine)
    dial::Int = 50
    dial_crossed_zero_count::Int = 0

    for instruction in lines
        next, overflows = apply_instruction(dial, instruction)
        dial_crossed_zero_count += overflows

        dial = next
    end

    @info "Dial crossed zero $(dial_crossed_zero_count) times"
end

@views function apply_instruction(dial::Int, instruction::AbstractString)::@NamedTuple{dial::Int,zeroes::Int}
    direction::Char = instruction[1]
    ticks::Int = parse(Int, instruction[2:end])

    if direction == 'L'
        zeroes, next = fldmod(dial - ticks, 100)
        zeroes *= -1 # normalize to positive

        # adjust for reaching zero exactly
        if dial == 0
            zeroes -= 1
        elseif next == 0
            zeroes += 1
        end

        @debug "$(instruction): $(dial) - $(ticks) = $(dial - ticks) := $(next) ($(zeroes))"

        return (dial=next, zeroes=zeroes)
    elseif direction == 'R'
        zeroes, next = fldmod(dial + ticks, 100)

        @debug "$(instruction): $(dial) + $(ticks) = $(dial + ticks) := $(next) ($(zeroes))"
        return (dial=next, zeroes=zeroes)
    end

    @warn "Unexpected instruction $(instruction)"
    return (dial=dial, zeroes=0)
end