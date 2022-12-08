function process_input(vector_lines::Vector{String})
    char_matrix = mapreduce(permutedims, vcat, collect.(Char, vector_lines))
    int_mat = parse.(Int, char_matrix)
    return int_mat
end

function count_visible(int_mat::AbstractArray{T}) where {T<:Number}
    mat_size = size(int_mat)
    visible = (mat_size[1] + mat_size[2]) * 2 - 4

    for row_idx in range(2, (mat_size[1] - 1)), col_idx in range(2, mat_size[2] - 1)
        my_tree = int_mat[row_idx, col_idx]
        if max(int_mat[row_idx, 1:col_idx-1]...) < my_tree || max(int_mat[row_idx, col_idx+1:end]...) < my_tree || max(int_mat[1:row_idx-1, col_idx]...) < my_tree || max(int_mat[row_idx+1:end, col_idx]...) < my_tree
            visible += 1
        end
    end

    return visible
end

function compute_view_distance(vec, my_tree)
    distance = 0
    for idx in eachindex(vec)
        if vec[idx] >= my_tree
            distance += 1
            break
        end
        distance += 1
    end
    return distance
end

function compute_scenic_scores(int_mat::AbstractArray{T}) where {T<:Number}
    mat_size = size(int_mat)
    scenic_mat = zeros(mat_size)
    for row_idx in range(2, (mat_size[1] - 1)), col_idx in range(2, mat_size[2] - 1)
        my_tree = int_mat[row_idx, col_idx]
        dist_left = compute_view_distance(reverse(int_mat[row_idx, 1:col_idx-1]), my_tree)
        dist_right = compute_view_distance(int_mat[row_idx, col_idx+1:end], my_tree)
        dist_up = compute_view_distance(reverse(int_mat[1:row_idx-1, col_idx]), my_tree)
        dist_down = compute_view_distance(int_mat[row_idx+1:end, col_idx], my_tree)
        scenic_mat[row_idx, col_idx] =  dist_left* dist_right * dist_up * dist_down 
    end

    return scenic_mat
end

vector_lines = readlines("input.txt")
int_mat = process_input(vector_lines)

#1
visible = count_visible(int_mat)

#2
scenic_mat = compute_scenic_scores(int_mat)
max_scenic_score = max(scenic_mat...)
