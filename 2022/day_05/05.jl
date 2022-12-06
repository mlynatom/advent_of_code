vector_lines = readlines("input.txt")

delimiter_index = indexin([""], vector_lines)[1]
stacks_str = vector_lines[1:delimiter_index-1]
instructions_str = vector_lines[delimiter_index+1:end]

function get_stack(stacks_str::AbstractVector{String})
    splitted = collect.(Char, stacks_str)

    mat = mapreduce(permutedims, vcat, splitted)

    stacks = permutedims(mat)

    bool_arr = isnumeric.(stacks[:, end])

    filtered_stacks = stacks[bool_arr, 1:end-1]

    return filter.(x -> x != " ", split.(map(join, eachrow(filtered_stacks)), ""))
end

stack = get_stack(stacks_str)

function get_instructions(instructions_str)
    check_str(str) = return tryparse(Int64, str) !== nothing
    splitted = filter.(check_str , split.(instructions_str, " "))

    parse_vec(line) = return parse.(Int64, line)
    parsed_nums = parse_vec.(splitted)

    return parsed_nums
end

instructions = get_instructions(instructions_str)

function process_instructions(instructions, stack; crane9001 = false)
    for instr in instructions
        from = instr[2]
        to = instr[3]
        count = instr[1]

        from_data = stack[from][1:count]
        if crane9001
            stack[to] = append!(from_data, stack[to])
        else
            stack[to] = append!(reverse(from_data), stack[to])
        end
        stack[from] = stack[from][1+count:end]

    end
    return stack
end

#1
ret = process_instructions(instructions, stack; crane9001=false)

#2
ret = process_instructions(instructions, stack; crane9001=true)

function get_tops(stack::Vector{Vector{T}}) where {T <: AbstractString}
    ret_vec = []
    for el in stack
        push!(ret_vec, el[1])
    end

    return join(ret_vec)
end

get_tops(ret)
