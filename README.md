IsoMatch: Creating Informative Grid Layouts
===========================================

Copyright and redistribution
----------------------------
Feel free to use, modify and redistribute this code.
- Make sure this notice is redistributed alongside the code.
- You acknowledge that the code is provided as-is, with no guarantees.
- When using the code in a publication, **please cite**

>O. Fried, S. DiVerdi, M. Halber, E. Sizikova and A. Finkelstein. "IsoMatch: Creating Informative Grid Layouts." 36th Annual Conference of the European Association for Computer Graphics (Eurographics), Kongresshaus in Zürich, Switzerland, 2015

Feel free to contact me (ohad-at-cs-dot-princeton-dot-edu) with questions, bug reports, and suggestions.
Also check out [my website](http://www.cs.princeton.edu/~ohad/) for this and other publications.

[IsoMatch Demo video](https://www.youtube.com/watch?v=WHSAOO8ekM0)

Getting started
---------------

Notice that the provided implementation only supports some of the features described in the paper. Please refer to the original publication for more extensions and improvements such as hierarchical arrangements and collection summarization.

### A simple isomatch example

The best place to start is `test.m`. The file should produce two colorful images, one unsorted and the other arranged via IsoMatch.

Let's do a step-by-step rundown of what's going on inside `test.m`:

In this example we will arrange random colors on a 20x20 grid. Let's start by specifying the grid size:
```
options = struct();
options.grid_size = [20 20];
```
And now let's generate some random colors:
```
rand_colors = rand(prod(options.grid_size), 3);
```
We will need to calculate a distance matrix that will contain all the pair-wise distances between our colors. In order to do that, we use the matlab functions `pdist` to calculate distances and `squareform` to convert a vector of distances to matrix form.
```
d_list = pdist(rand_colors);
d_matrix = squareform(d_list);
```
Now for the interesting part. We call `isomatch()` to do the heavy lifting.
```
result_assignment = isomatch(d_matrix, options);
```
Notice that if we want more data, namely the objective function values, we can use the longer syntax:
```
[result_assignment, obj_res, obj_orig] = isomatch(d_matrix, options);
```

Now that we have `result_assignment`, we can use it to assign our objects into grid cells. Specifically `rand_colors(result_assignment, :)` is what we need.

### More advanced scenarios

#### Complex patterns

Notice that the above example used a rectangular grid. It is important to realize that isomatch supports any arbitrary pattern, which can be very different from a regular grid (in the paper we show examples such as the shape of a bell). In order to use your own pattern, supply raw coordinates via `options.grid_coords`.

#### 3D and above

You are not limited to 2D. Use `options.isomap_ndims` to change the dimensionality of isomap's output. Use `options.grid_coords` to specify your own coordinated, in higher dimensions.

#### Refining the results

As explained in the paper, we can try to minimize our energy function in order to improve results. A naive implementation is provided which uses random swaps to lower the energy. Set `options.num_swaps` or `options.swap_threshold` to a value above 0 to activate random swaps. Notice that the more swaps you perform, the better the result (but execution time will be longer).
