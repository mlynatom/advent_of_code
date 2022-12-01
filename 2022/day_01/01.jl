vector_lines = readlines("input1.txt")

function get_calories(lines::Vector{String})
    tmp_calories = 0
    calories = Vector{Int64}()
    for line in lines
        if line != ""
            tmp_calories += parse(Int64, line)
        else
            append!(calories, tmp_calories)
            tmp_calories = 0
        end

    end

    return calories
end

calories = get_calories(vector_lines)

sorted_calories = sort(calories)

sorted_calories[end]

sum(sorted_calories[end-2:end])