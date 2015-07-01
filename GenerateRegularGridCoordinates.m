function [gridCoordinates] = GenerateRegularGridCoordinates(...
  num_rows, num_cols, from_x, to_x, from_y, to_y)
% GenerateRegularGridCoordinates -- Create 2D coordinates of a regular grid.
%
% [gridCoordinates] = GenerateRegularGridCoordinates(num_rows, num_cols)
%   Create grid coordinates in the ranges [0, 1], [0, 1].
%   The grid has 'num_rows' rows and 'num_cols' columns.
%
% [gridCoordinates] = GenerateRegularGridCoordinates(num_rows, num_cols, from_x, 
%                                                    to_x, from_y, to_y)
%   Create grid coordinates in the ranges [from_x, to_x], [from_y, to_y].
%   The grid has 'num_rows' rows and 'num_cols' columns.
%
% Arguments
%
% num_rows: Number of grid rows.
% num_cols: Number of grid columns.
% from_x: Smallest grid value on the x axis.
% to_x: Largest grid value on the x axis.
% from_y: Smallest grid value on the y axis.
% to_y: Largest grid value on the y axis.
%
% Return Values
%
%   gridCoordinates: A 2D matrix with the grid coordinates.

% If the boundary arguments are not specified, we assume both axis should
% be [0, 1].
if (nargin <= 2)
  from_x = 0;
  to_x = 1;
  from_y = 0;
  to_y = 1;
end

x_vals = linspace(from_x, to_x, num_cols);
y_vals = linspace(from_y, to_y, num_rows);

[Y,X] = meshgrid(y_vals, x_vals);
gridCoordinates = [X(:) Y(:)];

end

