vector_lines = readlines("input.txt")

#part1
function get_first_half(str::String)
    half = convert(Int, length(str)/2)
    return str[1:half]
end

function get_second_half(str::String)
    half = convert(Int, length(str)/2)
    return str[half+1:end]
end

first_halves = get_first_half.(vector_lines)
second_halves = get_second_half.(vector_lines)

mat = hcat(first_halves, second_halves)
#part2
chunks = collect(Iterators.partition(vector_lines, 3))
##

find_common_letter(str_vec) = intersect(str_vec...)[1]

#part1
common_letters = map(find_common_letter, eachrow(mat))
#part2
common_letters = find_common_letter.(chunks)

function convert_char_score(c::Char)
    int_val = convert(Int8, c)

    if int_val > Int8('Z')
        int_val = int_val - Int8('a') + 1
    else
        int_val = int_val - Int8('A') + 27
    end

    return int_val
end

scores = convert_char_score.(common_letters)

score = sum(scores)
