#!/usr/bin/python
import sys,os, pprint, random

import xpmp

m5 = [ 0,
       2863311530,
       3435973836,
       1717986918,
       4042322160,
       1515870810,
       1010580540,
       2526451350,
       4278255360,
       1437226410,
        869020620,
       2573637990,
        267390960,
       2774181210,
       3275539260,
       1771465110,
       4294901760,
       1431677610,
        859032780,
       2576967270,
        252702960,
       2779077210,
       3284352060,
       1768527510,
         16776960,
       2857719210,
       3425907660,
       1721342310,
       4027518960,
       1520805210,
       1019462460,
       2523490710]

m5_sorted = [(num, idx) for idx, num in enumerate(m5)]
m5_sorted.sort()

NOT_FOUND = -1

# Very naive and very slow approximate search
def approx_search(l, value):
    match = NOT_FOUND
    closest = sys.maxint

    for num, idx in l:
        if num_bits_diff(value, num) < closest:
            closest = num_bits_diff(value, num) #abs(value - num)
            match = idx

    return match

def encode(image):
# takes a list of integers and encodes them for transfer
    space_image = []
    for i in image.bw_pixels:
        space_image.append(m5[i])

    return space_image

def decode(image):
    fixed_image = []
    for i in image:
        fixed_image.append(approx_search(m5_sorted, i))

    return fixed_image

# Found at http://graphics.stanford.edu/~seander/bithacks.html#CountBitsSetParallel
def num_bits_diff(x, y):
    v = x ^ y
    c =  ((v & 0xfff) * 0x1001001001001 & 0x84210842108421) % 0x1f;
    c += (((v & 0xfff000) >> 12) * 0x1001001001001 & 0x84210842108421) % 0x1f;
    c += ((v >> 24) * 0x1001001001001 & 0x84210842108421) % 0x1f
    return c

powers_of_two = [1<<n for n in range(0,32)]
def introduce_error(image, bits_of_error=1):
    err_image = []
    for pixel in image:
        new_pixel = pixel
        for b in range(0, bits_of_error):
          bit2flip = random.choice(powers_of_two)
          new_pixel = new_pixel ^ bit2flip
          #print("pixel=",pixel," bit2flip=", bit2flip," diff=",num_bits_diff(new_pixel, pixel), " new_pixel=",(new_pixel))
        err_image.append(new_pixel)

    return err_image

def read_xpmp():
    f = open('avatar-small.xpmp', 'r')
    pic = f.read()
    f.close()

    return pic

pp = pprint.PrettyPrinter()

#pp.pprint(powers_of_two)

print("Reading in the image for transfer...")
image = xpmp.XPMP(read_xpmp())
print("Done reading image.")

for bit_error in range(1, 10+1):
    print("bit_error=%d" % bit_error)
    print("    Encoding image for transfer...")
    space_image = encode(image)
    print("    Done encoding image.")

    print("    Introducing error...")
    space_image = introduce_error(space_image, bit_error)
    print("    Havok caused.")

    if space_image == image.bw_pixels:
        print("    Space image not changed!")
    else:
        print("    Space image damaged!")

    print("    Fixing image...")
    fixed_image = decode(space_image)
    print("    Image fixed.")

    if image.bw_pixels == fixed_image:
        print("Image matches!")
    else:
        print("Image doesn't match!")


