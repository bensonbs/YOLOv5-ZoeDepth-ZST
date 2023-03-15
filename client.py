import requests
import json
import numpy as np
import base64,cv2
from PIL import Image, ImageOps
# Define gradient colors
red = (255, 0, 0)
green = (0, 255, 0)
yellow = (255, 255, 0)
# Define color map
color_map = {
    'truck': (0, 0, 255),  # Red
    'safety': (0, 255, 0),  # Green
    'illegal': (255, 0, 0),  # Blue
    'cone': (255, 255, 0),  # Blue
}

file = 'Demo/3.png'

with open(file, "rb") as img_file:
    b64_string = base64.b64encode(img_file.read())

img_base64 = str(b64_string)[2:-1]

r = requests.post('http://127.0.0.1:5001/upload', 
data = {
    'base64_str':f'{img_base64}',
    'Model_name':'LK FAB',
    'Deep_model':'True'
})

string = r.text
print(string)
dic = json.loads(string.replace("'", "\"")[1:-1])