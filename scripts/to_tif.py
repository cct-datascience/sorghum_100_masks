import PIL.Image as Image
import os
import sys

print("Image file",sys.argv[1])
image_path=sys.argv[1]
dest_path=os.path.splitext(image_path)[0] + '.tif'

im = Image.open(image_path)
im.save(dest_path)
