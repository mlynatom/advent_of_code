vector_lines = readlines("input.txt")

splitted_lines = split.(vector_lines, ",")

function check_my_bounds(vec::Vector{T}, check_function::Function) where {T <: AbstractString}
    bounds = get_bounds.(vec)
    checked_bounds = check_function(bounds)
    return checked_bounds
end

function get_bounds(str::AbstractString)
    split_str = split(str, "-")
    return parse.(Int64, split_str)
end

function check_fully_contains(vec::Vector{Vector{T}}) where {T <: Number}
    elf_1 = vec[1]
    elf_2 = vec[2]

    if (elf_1[1] >= elf_2[1] && elf_1[2] <= elf_2[2]) || (elf_2[1] >= elf_1[1] && elf_2[2] <= elf_1[2])
        return true
    else
        return false
    end
end

function check_overlaps(vec::Vector{Vector{T}}) where {T <: Number}
    elf_1 = vec[1]
    elf_2 = vec[2]

    if (elf_2[2] >= elf_1[1] >= elf_2[1]) || (elf_2[1] <= elf_1[2] <= elf_2[2]) || (elf_1[2] >= elf_2[1] >= elf_1[1]) || (elf_1[1] <= elf_2[2] <= elf_1[2])
        return true
    else
        return false
    end
end

#1
checked_bounds = check_my_bounds.(splitted_lines, check_fully_contains)
#2
checked_bounds = check_my_bounds.(splitted_lines, check_overlaps)

num_fully_contains = sum(checked_bounds)