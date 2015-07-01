function [img, mult_x, add_x, mult_y, add_y] = points2bwimage(x_vals, y_vals)
%POINTS2BWIMAGE Convert point locations to bw image

  IMG_NUM_COLS = 200;

  max_x_vals = max(x_vals);
  min_x_vals = min(x_vals);
  max_y_vals = max(y_vals);
  min_y_vals = min(y_vals);
  range_x_vals = max_x_vals - min_x_vals;
  range_y_vals = max_y_vals - min_y_vals;
  
  img_num_rows = IMG_NUM_COLS * range_y_vals / range_x_vals;
  img = false(ceil(img_num_rows), IMG_NUM_COLS);
  
  x_vals = x_vals - min_x_vals;
  mult_x = max(x_vals) ./ (IMG_NUM_COLS - 1);
  x_vals = x_vals ./ mult_x + 1; % x_vals in [1, IMG_NUM_COLS]
  y_vals = y_vals - min_y_vals;
  mult_y = max(y_vals) ./ (img_num_rows - 1);
  y_vals = y_vals ./ mult_y + 1; % y_vals in [1, img_num_rows]
  
  indices = sub2ind(size(img), round(y_vals), round(x_vals));
  img(indices) = true;
  
  add_x = min_x_vals;
  add_y = min_y_vals;
end

