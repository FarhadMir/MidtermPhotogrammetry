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

The test image uploaded as test3.jpg

Results are uploaded in result dir

![originalimage](https://user-images.githubusercontent.com/36164448/36244248-6b105e32-11f3-11e8-80a4-c36aa29e4d54.jpg)
![superpixelsegmentation](https://user-images.githubusercontent.com/36164448/36244252-6d2353aa-11f3-11e8-9b62-d27a307d7190.jpg)
![md](https://user-images.githubusercontent.com/36164448/36243919-070d67fa-11f2-11e8-8acb-86e65d8fc423.jpg)
![cd](https://user-images.githubusercontent.com/36164448/36243926-0a480664-11f2-11e8-9fe5-c5fa360150db.jpg)
![ms](https://user-images.githubusercontent.com/36164448/36243927-0cb17ebc-11f2-11e8-8465-3500b35c1839.jpg)
![cs](https://user-images.githubusercontent.com/36164448/36243929-0ea79648-11f2-11e8-8f06-16278fffce46.jpg)
![md cd](https://user-images.githubusercontent.com/36164448/36243932-1057cd32-11f2-11e8-90b5-7818938727ec.jpg)
![ms cs](https://user-images.githubusercontent.com/36164448/36243933-11da86c2-11f2-11e8-8863-147e9ab249e0.jpg)
![md cd ms cs](https://user-images.githubusercontent.com/36164448/36243935-13765042-11f2-11e8-9139-17d78ff9b99c.jpg)
