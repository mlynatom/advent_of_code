function are_four_letters_diff(str::String)
    chars = collect(str)
    return length(unique(chars)) >= length(chars)
end

function get_index(str::String; num_distinct::Int = 4)
    for i in range(num_distinct, length(str))
        if are_four_letters_diff(str[i-num_distinct+1:i])
            return i
        end
    end
end

str = readline("input.txt")

get_index(str; num_distinct=4)
get_index(str; num_distinct=14)