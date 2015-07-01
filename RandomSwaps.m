function [grid_permutation, obj_value] = RandomSwaps(image_dist_matrix, ...
                                                     grid_dist_matrix, ...
                                                     num_swaps, threshold)

if ~exist('threshold', 'var')
  threshold = 0;
end
                                        
if ~exist('num_swaps', 'var')
  num_swaps = 3e4;
end

n = size(image_dist_matrix, 1);

grid_permutation = 1:n;

% Calculate result for initial permutation
obj_value = EvaluateObjectiveFunc_internal(image_dist_matrix, grid_dist_matrix);

for ii = 1:num_swaps
  % if score is below threshold, we terminate the optimization
  if (obj_value < threshold)
    break;
  end
  
  % Swap 2 indices
  swap_indices = randi(n, 1, 2);
  grid_dist_matrix = Swap2Indices_matrix(grid_dist_matrix, n, swap_indices);
  grid_permutation = Swap2Indices_vector(grid_permutation, swap_indices);
  
  current_result = EvaluateObjectiveFunc_internal(image_dist_matrix, grid_dist_matrix);
  
  if (current_result > obj_value)
    % Revert if result made things worst
    grid_dist_matrix = Swap2Indices_matrix(grid_dist_matrix, n, swap_indices);
    grid_permutation = Swap2Indices_vector(grid_permutation, swap_indices);
  else
    % Update best result
    obj_value = current_result;
  end
end

end

function [m_out] = Swap2Indices_matrix(m, num_elements, ind_pair)
  indices = 1:num_elements;
  indices(ind_pair(1)) = ind_pair(2);
  indices(ind_pair(2)) = ind_pair(1);

  m = m(indices, :);
  m_out = m(:, indices);
end

function [v_out] = Swap2Indices_vector(v, ind_pair)
  tmp = v(ind_pair(1));
  v(ind_pair(1)) = v(ind_pair(2));
  v(ind_pair(2)) = tmp;
  v_out = v;
end

function [result, C] = EvaluateObjectiveFunc_internal(image_dist_matrix, grid_dist_matrix)
  dist_images = squareform(image_dist_matrix);
  dist_grid = squareform(grid_dist_matrix);
  
  [result, C] = EvaluateObjectiveFunc(dist_images, dist_grid);
end
