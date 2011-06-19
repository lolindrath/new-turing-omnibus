import sys, os, pprint

pp = pprint.PrettyPrinter()

class XPMP:
    def __init__(self, image):
        self.image = image;
        self.process()

    def process(self):
        exec(self.image)
        self.values = values
        self.colors = colors
        self.pixels = pixels

        self.bw_colors = {}
        self.bw_pixels = []

        for idx, color in enumerate(self.colors):
            self.bw_colors[color[0]] = (idx, color[2])

        for row in self.pixels:
            for pixel in row:
                self.bw_pixels.append(self.bw_colors[pixel][0])

