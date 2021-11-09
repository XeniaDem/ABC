import math
import random


# Class of triangle
class Triangle:
    # Constructor
    def __init__(self):
        self.x1 = 0
        self.y1 = 0
        self.x2 = 0
        self.y2 = 0
        self.x3 = 0
        self.y3 = 0
        self.color = ""
        self.perimeter = 0.0

    # Inputting triangle data from existing file
    def triangle_in(self, params):
        if len(params) != 8:
            print("Could not read string")
            return 1
        else:
            self.x1 = int(params[1])
            self.y1 = int(params[2])
            self.x2 = int(params[3])
            self.y2 = int(params[4])
            self.x3 = int(params[5])
            self.y3 = int(params[6])
            self.color = params[7]
            self.perimeter = self.side(self.x1, self.y1, self.x2, self.y2) + \
                             self.side(self.x1, self.y1, self.x3, self.y3) + \
                             self.side(self.x2, self.y2, self.x3, self.y3)

    # Getting random parameters for triangle
    def triangle_in_rnd(self):
        while ((self.side(self.x1, self.y1, self.x2, self.y2) >= self.side(self.x1, self.y1, self.x3, self.y3) +
               self.side(self.x2, self.y2, self.x3, self.y3)) or (self.side(self.x1, self.y1, self.x3, self.y3)
               >= self.side(self.x1, self.y1, self.x2, self.y2) + self.side(self.x2, self.y2, self.x3, self.y3)) or
               (self.side(self.x2, self.y2, self.x3, self.y3) >= self.side(self.x1, self.y1, self.x2, self.y2) +
               self.side(self.x1, self.y1, self.x3, self.y3))):
            self.x1 = random.randint(1, 1000)
            self.y1 = random.randint(1, 1000)
            self.x2 = random.randint(1, 1000)
            self.y2 = random.randint(1, 1000)
            self.x3 = random.randint(1, 1000)
            self.y3 = random.randint(1, 1000)
        self.get_color()
        self.perimeter = self.side(self.x1, self.y1, self.x2, self.y2) + \
                             self.side(self.x1, self.y1, self.x3, self.y3) + \
                             self.side(self.x2, self.y2, self.x3, self.y3)

    # Getting a side of triangle
    @staticmethod
    def side(x1, y1, x2, y2):
        return math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))

    # Outputting rectangle data to console and output file
    def out(self, file):
        output = ("Triangle: (" + str(self.x1) + "; " + str(self.y1) + "), (" + str(self.x2) + "; " + str(self.y2) + "); (" +
                  str(self.x3) + "; " + str(self.y3) + "); Color = " + self.color +
                  "Perimeter = " + str(self.perimeter))
        file.write(output)
        print(output)

    # Random generation for triangle color
    def get_color(self):
        color_int = random.randint(0, 6)
        if color_int == 0:
            self.color = "RED\n"
        if color_int == 1:
            self.color = "ORANGE\n"
        if color_int == 2:
            self.color = "YELLOW\n"
        if color_int == 3:
            self.color = "GREEN\n"
        if color_int == 4:
            self.color = "LIGHT_BLUE\n"
        if color_int == 5:
            self.color = "BLUE\n"
        if color_int == 6:
            self.color = "VIOLET\n"
        return 0

