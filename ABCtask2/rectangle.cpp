#include <fstream>
#include "rectangle.h"
#include "rnd.h"

int Rectangle::In(FILE *input_file) {
    char color_type[10001];
    int res = fscanf(input_file, "%d %d %d %d %10000s", &x_up_left, &y_up_left, &x_down_right, &y_down_right, color_type);
    if (res != 5) {
        printf("Could not read string\n");
        return 1;
    }
    color = GetColor(color_type);
    return 0;
}

void Rectangle::InRnd(FILE *input_rnd) {
    do {
        x_up_left = Shape::rnd1000.Get();
        y_up_left = Shape::rnd1000.Get();
        x_down_right = Shape::rnd1000.Get();
        y_down_right = Shape::rnd1000.Get();
    } while (x_up_left >= x_down_right || y_up_left <= y_down_right);
    int index = Shape::rnd7.Get();
    switch (index) {
        case 1:{
            color = Rectangle::Color::RED;
            break;
        }
        case 2:{
            color = Rectangle::Color::ORANGE;
            break;
        }
        case 3: {
            color = Rectangle::Color::YELLOW;
            break;
        }
        case 4: {
            color = Rectangle::Color::GREEN;
            break;
        }
        case 5: {
            color = Rectangle::Color::LIGHT_BLUE;
            break;
        }
        case 6: {
            color = Rectangle::Color::BLUE;
            break;
        }
        case 7: {
            color = Rectangle::Color::VIOLET;
            break;
        }
        default: {
            color = Rectangle::Color::RED;
            break;
        }
    }
    fprintf(input_rnd, "RECTANGLE %d %d %d %d %s \n", x_up_left, y_up_left, x_down_right, y_down_right, ColorToString(color).c_str());
}
void Rectangle::Out(FILE *output_file) {
    printf("Rectangle: (%d; %d); (%d; %d); Color = %s; \n Perimeter = %lf \n",
         x_up_left, y_up_left, x_down_right, y_down_right, ColorToString(color).c_str(), Perimeter());
    fprintf(output_file, "Rectangle: (%d; %d); (%d; %d); Color = %s; \n Perimeter = %lf \n",
            x_up_left, y_up_left, x_down_right, y_down_right, ColorToString(color).c_str(), Perimeter());
}

double Rectangle::Perimeter() {
    return 2 * (abs(x_up_left - x_down_right) + abs(y_up_left - y_down_right));
}

std::string Rectangle::ColorToString(Color color) {
    switch (color) {
    case RED:
        return "RED";
    case ORANGE:
        return "ORANGE";
    case YELLOW:
        return "YELLOW";
    case GREEN:
        return "GREEN";
    case LIGHT_BLUE:
        return "LIGHT_BLUE";
    case BLUE:
        return "BLUE";
    case VIOLET:
        return "VIOLET";
    default:
        return "NOT A COLOR!";
    }
}

Rectangle::Color Rectangle::GetColor(char color_type[10001]) {
    if (strcmp(color_type, "RED") == 0)
        return RED;
    if (strcmp(color_type, "ORANGE") == 0)
        return ORANGE;
    if (strcmp(color_type, "YELLOW") == 0)
        return YELLOW;
    if (strcmp(color_type, "GREEN") == 0)
        return GREEN;
    if (strcmp(color_type, "LIGHT_BLUE") == 0)
        return LIGHT_BLUE;
    if (strcmp(color_type, "BLUE") == 0)
        return BLUE;
    if (strcmp(color_type, "VIOLET") == 0)
        return VIOLET;
    return VIOLET;
}