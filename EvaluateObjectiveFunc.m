function [result, C] = EvaluateObjectiveFunc(distances1, distances2)

    % distances1 and distances2 hold pair-wise distances between objects.
    % Usually, distances1 will contain pair-wise distances between input
    % objects (e.g. color difference between images) and distances2 will
    % contain Euclidean distances between grid locations. 
    
    % distances1 and distances2 must be the same size. The assignment is
    % implicit according to the element order (i.e. distances1(k) and
    % distances2(k) contain the distance between the same pair of objects).

    [~, ~, result, ~, ~, C] = EvaluateObjectiveFunc_internal(...
        distances1, distances2);
end

function [result, result_w, result_l1, C, C_w, C_l1] = ...
    EvaluateObjectiveFunc_internal(distances1, distances2)

% Objective function 1: without weighting
% ---------------------------------------
% Our objective function is as follows:
% Let x_i be an original distance and x_i' the distance on the output grid 
% (for the same pair i). We would like to minimize the distance distortion, 
% namely:
% min(\sum_{i} (C * x_i - x_i') ^ 2)
% We notice that for fixed x_i and x_i' we can solve for C, getting the 
% expression below.
              
% Calculagte the mult factor that yields the best result for our objective 
% function.              
C = sum(distances1 .* distances2) / sum(distances1 .^ 2);

% Return the result. The smaller the better.
result = sqrt(sum((C .* distances1 - distances2) .^ 2)) / ...
         sqrt(sum(distances2 .^ 2));

% We divide by numel(dist_orig) to make sure we can compare results across 
% differently sized datasets.
% We divide by sqrt(sum(dist_orig .^ 2)) to make sure we get the same 
% result if all distances are multiplied by some constant.

% Objective function 2: with weighting
% ------------------------------------
ALPHA = 2;
max_dist_orig = max(distances1);
D = (1 - (distances1 ./ max_dist_orig)) .^ ALPHA;
C_w = sum(D .* distances1 .* distances2) / sum(D .* distances1 .^ 2);
result_w = sqrt(sum((C_w .* distances1 - distances2) .^ 2 .* D)) / ...
           sqrt(sum(distances2 .^ 2));

% Objective function 3: L1 (this is the one we report throughout the paper)
% -------------------------------------------------------------------------

% We prefer L1 since it does not overpenalize outliers. The C_l1 which
% minimizes the objective can be calculated efficiently due to the fact
% that our function is convex, and is a combination of linear functions.

C_l1 = FindMinimizerL1(distances1, distances2);
result_l1 = sum(abs(C_l1 .* distances1 - distances2)) / ...
            sum(distances2);
end

% Find a minimizer C to the function f(C) = \sum_{i} |C * x_i - y_i| 
% (x_i and y_i are 2n constants, each of them >= 0)
function [C_min] = FindMinimizerL1(x, y)
  x = x(:);
  y = y(:);
  assert(numel(x) == numel(y));
  
  % The minimum of the function will surely be achieved by one of the following 
  % C values:
  candidates = y ./ x;
  
  % Slow method (for comparison):
  %{
  result = zeros(numel(candidates), 1);
  for ii = 1:numel(candidates)
    result(ii) = sum(abs(candidates(ii) .* x - y));
  end
  [~, min_ind] = min(result);
  C_min = candidates(min_ind);
  %}
  
  % Fancier method:
  [~, sort_order] = sort(candidates);
  x_sorted = x(sort_order);
  tmp1 = cumsum(x_sorted(end:-1:1));
  tmp1 = [tmp1(end:-1:1) ; 0];
  tmp2 = [0 ; cumsum(x_sorted)];  
  % zero crossing of indicators shows the min
  indicators = tmp2 - tmp1;
  % our index is where indicators2 <= 0 (we take the first one)
  indicators2 = sign(indicators(1:(end-1))) .* sign(indicators(2:end));
  C_min = candidates(sort_order(indicators2 <= 0));
  C_min(2:end) = [];
end

