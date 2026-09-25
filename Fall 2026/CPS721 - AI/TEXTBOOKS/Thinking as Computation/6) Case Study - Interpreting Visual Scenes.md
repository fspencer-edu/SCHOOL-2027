- Visual interpretation
	- Form of constraint satisfaction
- Interpretation of an image of a 2D terrain from above
- Interpretation of the edges in an image of 3D polyhedral objects
- Recognizing objects of interest in an image
# The thinking part of vision

- Vision is the process of identifying the physical objects around us by interpreting the patterns of light that reflect off them
- Representing by a 2D grid of pixels
- Image components
	- Regions or edges that appear in an image
- Interpret 
	- Identify what the regions or edges actually represent in the scene
# Aerial sketch maps

- Statements constrain the permissible interpretations of regions that appear in images in terms of size, shape, borders, and containment
## Constraints on image regions

- List of regions, along with the properties they have in the image
- Variables
	- Regions of the image
	- Each variable must take a value from one of the region types
- Constraints
	- Image properties and background knowledge about the permissible interpretations of region types

<img src="/images/Pasted image 20260925134309.png" alt="image" width="500">

- Constraints work together to identify the regions and that there can be redundancy

# Polyhedral objects

- Interpreting an image of a polyhedral object involves labeling each edge

<img src="/images/Pasted image 20260925134422.png" alt="image" width="500">
## Constraints on vertices and edges

## Impossible objects

- Impossible objects
	- Images having only local interpretations
# Object recognition

- The task of object recognition is to determine whether the image contains a depiction fo a particular object

## Handling occlusion

