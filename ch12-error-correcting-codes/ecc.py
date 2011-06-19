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
       2523490710];

def encode(image):
# takes a list of integers and encodes them for transfer
    space_image = []
    for i in image.bw_pixels:
        space_image.append(m5[i])
    return space_image

#TODO: figure out how to determine closest row in the best time
def decode(image):
    pass

#TODO: Allow multiple bits of error, up to 32
def introduce_error(image, bits_of_error=1):
    powers_of_two = [2**n for n in range(1,32)]

    for pixel in image:
        bit2flip = random.choice(powers_of_two)
        pixel = pixel | bit2flip

def read_xpmp():
    f = open('avatar-small.xpmp', 'r')
    pic = f.read()
    f.close()

    return pic

pp = pprint.PrettyPrinter()

print("Reading in the image for transfer...")
image = xpmp.XPMP(read_xpmp())
print("Done reading image.")

print("Encoding image for transfer...")
space_image = encode(image)
print("Done encoding image.")

print("Introducing error...")
space_image = introduce_error(space_image)
print("Havok caused.")




