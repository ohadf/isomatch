function [reverse_assignment, obj_val_fin, obj_val_init] = ...
    isomatch(d_matrix, varargin)
% isomatch -- assign elements to locations while preserving distances
%
% [reverse_assignment, obj_val_fin, obj_val_init] = isomatch(d_matrix, varargin)
%   Calculate the assignment according to distance matrix d_matrix. 
%   obj_val_init and obj_val_fin are the initial and final energy values.
%   The function accepts either an options struct or name value pairs.
%
% Supported options
%
% grid_size: if arranging on a regular grid, specifies its size
% grid_coords: if arranging in arbitrary locations, specifies the raw
%              coordinates
% num_swaps: amount of swaps in random-swap phase
% swap_threshold: random-swap will continue until energy below threshold
% isomap_neighbor_count: see isomap docs
% isomap_ndims: number of dimentions in isomap's output
%
% Return Values
%
%   reverse_assignment: a permunation of 1:n, determining the assignment
%   obj_val_init: energy value of input
%   obj_val_fin: energy value of output

  addpath('./external/IsomapR1/');
  addpath('./external/munkres/');
  
  % parse input arguments
  
  p = inputParser;

  % add required parameters
  addRequired(p, 'd_matrix', @ValidateDistanceMatrix);  
  % add optional name-value pairs
  addParameter(p, 'isomap_neighbor_count', 13);
  addParameter(p, 'isomap_ndims', 2);
  addParameter(p, 'grid_size', []);
  addParameter(p, 'grid_coords', []);
  addParameter(p, 'num_swaps', 0);
  addParameter(p, 'swap_threshold', 0);

  parse(p, d_matrix, varargin{:});
  options = p.Results;
 
  % Find a 2d embedding using isomaps
  timer_val = tic;
  iso_options.dims = options.isomap_ndims;
  iso_options.display = 0;
  iso_options.verbose = 0;
  [Y, ~, ~] = Isomap(d_matrix, 'k', options.isomap_neighbor_count, iso_options);
  fprintf('isomap execution time: %f seconds.\n', toc(timer_val));
  
  num_images = length(Y.index);
  isomap_result_x = Y.coords{1}(1, :)';
  isomap_result_y = Y.coords{1}(2, :)';

  % course alignment
  grid_rectangle = CalculateBoundingBoxRectangle(isomap_result_x, ...
                                                 isomap_result_y);
  
  locations = [isomap_result_x isomap_result_y];
    
  % Setup min-weight matching to assign images to grid points

  fprintf('Calculating bipartite matching...\n');
    
  if isempty(options.grid_coords)
    % if grid_coords were not supplied externally, we constract a regular
    % grid. Note that we assume options.grid_size was supplied by the user.
    
    assert(~isempty(options.grid_size));
    
    grid_coords = GenerateRegularGridCoordinates(options.grid_size(1), ...
      options.grid_size(2), grid_rectangle(1), grid_rectangle(3), ...
      grid_rectangle(2), grid_rectangle(4));
    % We don't need the last cells of the grid
    grid_coords(num_images+1:end, :) = [];
  else
    % if grid_coords were supplied externally, we use it as-is
    grid_coords = options.grid_coords;
  end
  
  % Calculate best match
  [~, assignment] = MatchToGrid(locations, grid_coords);

  % Make sure 'assignment' is a permutation of 1:N
  assert(all(unique(assignment) == (1:num_images)'));

  new_grid_coords = grid_coords(assignment, :);
  
  % Improve via rand swaps (if num_swaps or threshold were specified)
  grid_perm = 1:numel(assignment);
  if (options.num_swaps > 0 || options.swap_threshold > 0)
    timer_val = tic;
    grid_perm = RandomSwaps(d_matrix, squareform(pdist(new_grid_coords)), ...
                            options.num_swaps, options.swap_threshold);
    fprintf('Random swaps execution time: %f seconds.\n\n', toc(timer_val));
  end
  
  % Calculate the objective values (for initial and final arrangement)
  d_list = squareform(d_matrix);
  obj_val_init = EvaluateObjectiveFunc(d_list, pdist(grid_coords));
  obj_val_fin = EvaluateObjectiveFunc(d_list, ...
                                      pdist(new_grid_coords(grid_perm, :)));
                                        
  [~, reverse_assignment] = sort(assignment(grid_perm));                                        
end

function [isvalid] = ValidateDistanceMatrix(d_matrix)
  % make sure d_matrix is symetric with 0s on diagonal
  if all(all(d_matrix == d_matrix')) && ~any(diag(d_matrix))
    isvalid = true;
  else
    isvalid = false;
  end
end