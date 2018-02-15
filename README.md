# PhotogrammetryProject
The goal of this project is to decompose a single image (observed color) to two image of true object color and illumination along with two scale images corresponding to each.
To that extent, first the input image segmented with superpixel method to reduce the number of unknowns for the true color image.

A gradient descent method has been used to minimize the following cost function:

(scale_true_color * truecolor + scale_illumination * illumination - observed_color)^2

with itration:

x_k+1 = x_k - alpha * Gradient_x @ x_k

and Initialization of:

scale_true_color = scale_illumination = 0.5

illumination = 0.784

truecolor = mean value of the subpixels in a superpixel
