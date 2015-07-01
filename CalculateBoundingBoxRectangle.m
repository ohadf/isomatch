function [out_rectangle] = CalculateBoundingBoxRectangle(x, y)

  % We calculate a loose bounding box for all point, such that outliers are
  % discarded
  
  % Convert point coordinates to an image
  [isomap_bw, mult_x, add_x, mult_y, add_y] = points2bwimage(x, y);
  
  % Use gaussians and thresholding. Each point votes for it's surroundings
  h = fspecial('gaussian', 31, 10) .* 20;
  isomap_gray = conv2(double(isomap_bw), h, 'same');
  level = graythresh(isomap_gray);
  isomap_bw2 = im2bw(isomap_gray, level);
  
  % Pick the largest component
  B = bwboundaries(isomap_bw2, 'noholes');
  numPixels = cellfun(@numel, B) ./ 2;
  [~, ind_max] = max(numPixels);
  boundary_pixels = B{ind_max};
  
  % Swap to match the (x, y) convention (as apposed to (y, x))
  boundary_pixels = fliplr(boundary_pixels);
  
  % map back to isomap coordinated
  boundary_pixels(:, 1) = (boundary_pixels(:, 1) - 1) .* mult_x + add_x;
  boundary_pixels(:, 2) = (boundary_pixels(:, 2) - 1) .* mult_y + add_y;
  
  out_rectangle = [min(boundary_pixels(:, 1)) min(boundary_pixels(:, 2)) ...
                   max(boundary_pixels(:, 1)) max(boundary_pixels(:, 2))];
end
