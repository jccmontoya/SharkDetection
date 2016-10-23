# SharkDetection

GitHub repository for the navigation for the Shark Detection code.

See **Quantification of shark collective behaviour.docx** for further details 
about the code.

# Shark labeling
	
Shark labeling process started by selecting an image to be scrutinized. 
In order to alleviate labeling all sharks sighted in a single 
frame, each image was cropped and adjusted to smaller areas of interest containing 
individuals. Further, an iterative process was initiated for which the cropped area 
was decomposed into sub-images that were magnified to ensure accurate labeling. 

# Post-processing analysis 
For each sub-image, the observer located the individual shark by clicking 
on the most distant points of each individual, i.e., the tip of the head (Hx,Hy) 
and tip of the tail (Tx,Ty). This provided the central position, as the mean 
of those two points (Cx,Cy), the relative body length (Bl) as the Euclidean 
distance between head and tail (in pixels) and the swimming orientation (u,v) 
of each individual. The magnitude of the (u,v) vector was fixed to the labeled 
shark length, although this parameter could be set as a constant since we were 
primarily interested on estimating sharks orientation . Once all individuals 
observed in a sub-image were labeled, the labeling process continued until 
the whole cropped area was scanned. It is worth noticing that while we divided 
the labeling process into sub-windows, the final position of all sharks were 
outputted with respect to the origin of coordinates in the complete image, 
with (0,0) position corresponding to the upper left corner.

The relative body length of each labeled sharks was calculated as the Euclidean 
distance between head and tail labeled points.
In order to quantify the distance between individuals, the nearest neighbour 
to each labeled shark was determined using the central position (Cx,Cy) as 
a reference. For each shark?s central position, our algorithm again calculated 
the Euclidean distance towards all labeled sharks and only retained index of 
the individual identity that minimized this distance. Once all nearest neighbours
were determined, we calculated the level of alignment between an individual 
and its closest neighbour using their swimming orientation (u,v) and the magnitude 
of the vectors for comparison. Based on these values, the swimming alignment 
was calculated using the Dot Product.

Values of each individual shark (the distance to its nearest companion, alignment level) 
were compared to the median estimates for the shoal sighted in a sampled image.
 We assumed that an individual was swimming in a coordinated manner with its nearest 
neighbour if the relative distance between them was smaller than 2 relative body 
lengths (in pixels). This criterion (threshold) was based on the median of the 
set of body lengths, Ls, of all individuals measured on a given sampled image.

Then, the median was calculated as the  value of the sorted series, Ls. 
Distances between two closest individuals smaller than the established threshold 
are outputted as red colored asterisks, where an asterisk represented the central 
position (Cx,Cy) of each shark labeled on a sampled frame. Blue asterisks indicated 
between-individuals distances greater than the threshold. The median angle between 
all pairs of sharks present in a frame was used as a threshold to evaluate 
how well sharks were aligned with their closest neighbour. 

# Authors and Contributors

Shark Detection toolbox was designed and developed by [José Carlos Castillo](https://github.com/jccmontoya) (developer, maintainer).


## LICENSE

The license of the packages is custom LASR-UC3M (Licencia Académica Social
Robotics Lab - UC3M), an open, non-commercial license which enables you to 
download, modify and distribute the code as long as you distribute the sources.  


