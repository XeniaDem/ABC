import random


# Class of rectangle
class Rectangle:
    def __init__(self):
        self.x_up_left = 0
        self.y_up_left = 0
        self.x_down_right = 0
        self.y_down_right = 0
        self.color = ""
        self.perimeter = 0.0

    # Inputting rectangle data from existing file
    def rectangle_in(self, params):
        if len(params) != 6:
            print("Could not read string")
            return 1
        else:
            self.x_up_left = int(params[1])
            self.y_up_left = int(params[2])
            self.x_down_right = int(params[3])
            self.y_down_right = int(params[4])
            self.color = params[5]
            self.perimeter = 2 * (abs(self.x_up_left - self.x_down_right)
                                  + abs(self.y_up_left - self.y_down_right))

    # Getting random parameters for rectangle
    def rectangle_in_rnd(self):
        while self.x_up_left >= self.x_down_right | self.y_up_left <= self.y_down_right:
            self.x_up_left = random.randint(1, 1000)
            self.y_up_left = random.randint(1, 1000)
            self.x_down_right = random.randint(1, 1000)
            self.y_down_right = random.randint(1, 1000)
        self.get_color()
        self.perimeter = 2 * (abs(self.x_up_left - self.x_down_right)
                                + abs(self.y_up_left - self.y_down_right))

    # Outputting rectangle data to console and output file
    def out(self, file):
        output = ("Rectangle: (" + str(self.x_up_left) + "; " + str(self.y_up_left) + "); (" + str(self.x_down_right)
                  + "; " + str(self.y_down_right) + "); Color = " + self.color + "Perimeter = " + str(self.perimeter))
        file.write(output)
        print(output)

    # Random generation for rectangle color
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

