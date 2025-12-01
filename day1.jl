import Logging

function (@main)(args)
    pt1(eachline(args[1]))
end

function pt1(lines)
    dial::Int = 50;
    dial_zero_count::Int = 0
    for (line, value) in enumerate(lines)
        direction = SubString(value, 1, 1)
        ticks = parse(Int, SubString(value, 2))


        if direction == "L"
            dial = mod(dial - ticks, 100)
            @debug "Got L$(ticks), new dial is $(dial)"
        elseif direction == "R"
            dial = mod(dial + ticks, 100)
            @debug "Got R$(ticks), new dial is $(dial)"
        else
            @warn "Unexpected direction '$(direction)' at line $(line) '$(value)'"
        end

        if dial == 0
            @info "Dial zero after line $(line) '$(value)'"
            dial_zero_count = dial_zero_count + 1
        end
    end

    @info "Dial was zero $(dial_zero_count) times"
end