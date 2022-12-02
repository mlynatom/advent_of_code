win_points = 6
draw_points = 3

win_dict = Dict{Char, Char}('A' => 'B', 'B' => 'C', 'C' => 'A')
lose_dict = Dict{Char, Char}('A' => 'C', 'B' => 'A', 'C' => 'B')
scores_dict = Dict{Char,Int64}('A' => 1, 'B' => 2, 'C' => 3)
convert_dict = Dict{Char, Char}('X' => 'A', 'Y' => 'B', 'Z' => 'C')

convert_fail(c::Char) = get(lose_dict, c, c)
convert_win(c::Char) = get(win_dict, c, c)

function game_score(game_round::Vector{Char})
    score = 0
    my_move = game_round[2]
    opponent_move = game_round[1]

    if opponent_move == my_move
        score += draw_points
    
    elseif my_move == win_dict[opponent_move]
        score += win_points

    end

    return score
end

convert_scores(c::Char) = get(scores_dict, c, 0)

get_my_moves(game_round) = game_round[end]
get_oponnent_moves(game_round) = game_round[1]

function get_matrix_repre(vector_lines::Vector{String})
    my_moves = get_my_moves.(vector_lines)
    op_moves = get_oponnent_moves.(vector_lines)
    return cat(op_moves, my_moves, dims=2)
end

function convert_task2(vector_lines::Vector{String})
    mat = get_matrix_repre(vector_lines)

    bool_vec_y = mat[:, 2] .== 'Y'
    bool_vec_x = mat[:, 2] .== 'X'
    bool_vec_z = mat[:, 2] .== 'Z'

    mat[bool_vec_y, 2] = mat[bool_vec_y, 1]
    mat[bool_vec_x, 2] = convert_fail.(mat[bool_vec_x, 1])
    mat[bool_vec_z, 2] = convert_win.(mat[bool_vec_z, 1])

    return mat
end

convert_char(c::Char) = get(convert_dict, c, c)

function convert_task1(vector_lines::Vector{String})
    mat = get_matrix_repre(vector_lines)
    mat[:, 2] = convert_char.(mat[:,2])

    return mat
end



vector_lines = readlines("input.txt")

game = convert_task1(vector_lines)
usage_score = sum(convert_scores.(game[:, 2]))
scores = map(game_score, eachrow(game))   
result = sum(scores) + usage_score

game = convert_task2(vector_lines)
usage_score = sum(convert_scores.(game[:, 2]))
scores = map(game_score, eachrow(game))   
result = sum(scores) + usage_score