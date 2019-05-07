
'''
Adds numbers to a sprite sheet for easy reference
'''
from PIL import Image
from PIL import ImageFont
from PIL import ImageDraw

if __name__ == '__main__':
    
    # get parameters
    IMG_NAME = input('Enter name of image: ')    
    TILE_SIZE = float(input('Enter Tile Size: '))
    MARGIN =  float(input('Enter margin: '))
    TILE_SIZE += MARGIN

    # open img
    img = Image.open(IMG_NAME)
    draw = ImageDraw.Draw(img)
    font = ImageFont.truetype('../fonts/font.ttf', 8)
    
    counter = 1
    
    # loop through image
    for y in range(int(img.height / TILE_SIZE)+1):
        for x in range(int(img.width / TILE_SIZE)+1):
            draw.text((x * TILE_SIZE + 1, y * TILE_SIZE), str(counter), (0, 0, 0), font=font)
            draw.text((x * TILE_SIZE, y * TILE_SIZE + 1), str(counter), (0, 0, 0), font=font)
            draw.text((x * TILE_SIZE, y * TILE_SIZE), str(counter), (255, 0, 255), font=font)
            counter += 1
    
    img.save(IMG_NAME.strip('.png') + '_numbered.png')