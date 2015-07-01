function [] = test()  
  % Either supply a grid size (for a regular grid) or specific target
  % locations
  options = struct();
  options.grid_size = [20 20];
  
  % Uncomment to test random swaps as refinement
  %options.num_swaps = 3e3;
  
  % Generate random colors
  rand_colors = rand(prod(options.grid_size), 3);

  % Assign using IsoMatch
  timer_val = tic;
  d_list = pdist(rand_colors);
  d_matrix = squareform(d_list);
  [result_assignment, obj_res, obj_orig] = isomatch(d_matrix, options);
  fprintf('IsoMatch total execution time: %f seconds.\n\n', toc(timer_val));
  
  % Display results

  subplot(1, 2, 1); 
  imshow(CreateColorGrid(rand_colors, options.grid_size));
  title(['Original ' num2str(obj_orig, '%.3f')]);

  subplot(1, 2, 2); 
  imshow(CreateColorGrid(rand_colors(result_assignment, :), options.grid_size));
  title_extra_txt = '';
  if isfield(options, 'num_swaps')
    title_extra_txt = sprintf('(rand swaps) ');
  end
  title(['Result ' title_extra_txt num2str(obj_res, '%.3f')]);
end

function [color_grid] = CreateColorGrid(colors, grid_size)
  color_grid = reshape(colors, [grid_size 3]);
end

