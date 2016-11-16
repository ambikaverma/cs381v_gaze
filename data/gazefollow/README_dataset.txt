GazeFollow Dataset
In this package we provide the GazeFollow dataset. Along with the package of images, we provide the following annotations:

- Bounding box annotation: The bounding box format is [x_initial y_initial w h]. (x_initial,y_initial) is the top left corner and (w,h) are width and height values. The values assume that images are size 1x1.  
- Gaze annotation: The gaze annotation format is (x,y) where the image is assumed to have size 1x1.
- Eye center annotation: The eye center annotation format is (x,y) where the image is assumed to have size 1x1.
- Image path
- Meta Data: The metadata structure contains the original image name as well as the dataset where it comes from.


Reference to the paper:
@inproceedings{nips15_recasens,
 author = "Adria Recasens$^*$ and Aditya Khosla$^*$ and Carl Vondrick and Antonio Torralba",
 title = "Where are they looking?",
 booktitle = "Advances in Neural Information Processing Systems (NIPS)",
 year = "2015",
 note = "$^*$ indicates equal contribution"
}

