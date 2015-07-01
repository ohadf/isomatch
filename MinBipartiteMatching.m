function [assignment_from, assignment_to] = MinBipartiteMatching(distMatrix)
% MinBipartiteMatching -- Calculate the minimal cost bipartite matching.
%
% [assignment_from, assignment_to] = MinBipartiteMatching(distMatrix)
% Given a weighted bipartite graph, we calculate a matching in the graph
% such that edge weights are minimal.
%
% Arguments
%
% distMatrix: An MxN matrix representing a bipartite graph with M vertices
%             on one side and N on the other side. The matrix contains the edge
%             weights.
%
% Return Values
%
% assignment_from:
% assignment_to: 
%   Two column vectors specifying the minimal bipartite matching.
%   Vertex assignment_from(i) (in V) is assigned to vertex assignment_to(i) 
%   (in U). Usually assignment_from would be 1:n.

distMatrix = distMatrix';

size_u = size(distMatrix, 1);
size_v = size(distMatrix, 2);

% Use hungarian algorithm
timerVal = tic;
x = munkres(distMatrix);
fprintf('munkres execution time: %f seconds.\n', toc(timerVal));  

[assignment_to, assignment_from] = ind2sub([size_u size_v], find(x));

end
