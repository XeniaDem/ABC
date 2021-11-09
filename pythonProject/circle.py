import math
import random


# Class of circle
class Circle:
    # Constructor
    def __init__(self):
        self.x = 0
        self.y = 0
        self.rad = 0
        self.perimeter = 0.0
        self.color = ""

    # Inputting circle data from existing file
    def circle_in(self, params):
        if len(params) != 5:
            print(len(params))
            print("Could not read string")
            return 1
        else:
            self.x = int(params[1])
            self.y = int(params[2])
            self.rad = int(params[3])
            self.color = params[4]
            self.perimeter = 2 * math.pi * self.rad

    # Getting random parameters for circle
    def circle_in_rnd(self):
        self.x = random.randint(1, 1000)
        self.y = random.randint(1, 1000)
        self.rad = random.randint(1, 1000)
        self.get_color()
        self.perimeter = 2 * math.pi * self.rad

    # Getting random parameters for circle
    def out(self, file):
        output = ("Circle: (" + str(self.x) + "; " + str(self.y) + "); radius = " + str(self.rad) +
                  "; Color = " + self.color + "Perimeter = " + str(self.perimeter))
        file.write(output)
        print(output)

    # Outputting circle data to console and output file
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
