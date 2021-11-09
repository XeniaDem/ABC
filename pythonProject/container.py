import random
import triangle
import circle
import rectangle


# Class of container
class Container:
    # Constructor
    def __init__(self):
        self.size = 0
        self.content = []

    # Filling container with objects from existing file
    def container_in(self, file):
        for line in file:
            params = line.split(' ')
            str_type = params[0]
            if str_type == "CIRCLE":
                c = circle.Circle()
                c.circle_in(params)
                self.content.append(c)
            if str_type == "RECTANGLE":
                r = rectangle.Rectangle()
                r.rectangle_in(params)
                self.content.append(r)
            if str_type == "TRIANGLE":
                t = triangle.Triangle()
                t.triangle_in(params)
                self.content.append(t)
        self.size = len(self.content)

    # Filling container with randomly generated objects
    def container_in_rnd(self, size, file):
        file.write(str(size) + "\n")
        self.size = int(size)
        for i in range(int(size)):
            shape_type = random.randint(0, 2)
            if shape_type == 0:
                c = circle.Circle()
                c.circle_in_rnd()
                self.content.append(c)
                file.write("CIRCLE " + str(c.x) + " " + str(c.y) + " " + str(c.rad) + " " + c.color)
            if shape_type == 1:
                r = rectangle.Rectangle()
                r.rectangle_in_rnd()
                self.content.append(r)
                file.write("RECTANGLE " + str(r.x_up_left) + " " + str(r.y_up_left) + " " +
                           str(r.x_down_right) + " " + str(r.y_down_right) + " " + r.color)
            if shape_type == 2:
                t = triangle.Triangle()
                t.triangle_in_rnd()
                self.content.append(t)
                file.write("TRIANGLE " + str(t.x1) + " " + str(t.y1) + " " + str(t.x2) + " " + str(t.y2) +
                           " " + str(t.x3) + " " + str(t.y3) + " " + t.color)

    # Sorting elements in container in descending
    def container_sort_elements(self):
        for i in range(1, self.size):
            for j in reversed(range(1, i + 1)):
                if self.content[j - 1].perimeter < self.content[j].perimeter:
                    self.content[j - 1], self.content[j] = self.content[j], self.content[j - 1]

    # Outputting container data to file
    def container_out(self, file):
        print("Container contains " + str(self.size) + " elements:\n")
        file.write("Container contains " + str(self.size) + " elements:\n")
        for i in range(self.size):
            print(str(i) + ". ")
            file.write(str(i) + ". ")
            self.content[i].out(file)
            file.write("\n")
