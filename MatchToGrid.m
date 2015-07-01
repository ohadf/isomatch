function [assignment_from, assignment_to] = MatchToGrid(orig_coords, grid_coords)
% MatchToGrid -- Find the best assignment of coordinates to grid coordinates.
%
% [assignment] = MatchToGrid(orig_coords, grid_coords)
%   Given original coordinates and output grid coordinates, we assign each input 
%   point to a given grid location.
%
% Arguments
%
% orig_coords: Nx2 with X/Y coordinates of point we wish to snap to grid.
% grid_coords: Mx2 with X/Y coordinates of grid. Note that M > N must hold.
%
% Return Values
%
% assignment: A column vector with the correct assignment. The point at 
%             orig_coords(k, :) is assigned to the point at 
%             grid_coords(assignment(k), :).

D = pdist2(orig_coords, grid_coords);

[assignment_from, assignment_to] = MinBipartiteMatching(D);

end
