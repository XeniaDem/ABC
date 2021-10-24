
#include <fstream>
#include <cmath>
#include <cstring>
#include "circle.h"
#include "rnd.h"

int Circle::In(FILE *input_file)
{
    char color_type[10001];
    int res = fscanf(input_file, "%d %d %d %s", &x, &y, &rad, color_type); 
    if (res != 4)
    {
        printf("Could not read string\n");
        return 1;
    }
    color = GetColor(color_type);
    return 0;
}

void Circle::InRnd(FILE *input_rnd){
    x = Shape::rnd1000.Get();
    y = Shape::rnd1000.Get();
    rad = Shape::rnd1000.Get();
    int index = Shape::rnd7.Get();
    switch (index) {
        case 1:{
            color = Circle::Color::RED;
            break;
        }
        case 2:{
            color = Circle::Color::ORANGE;
            break;
        }
        case 3: {
            color = Circle::Color::YELLOW;
            break;
        }
        case 4: {
            color = Circle::Color::GREEN;
            break;
        }
        case 5: {
            color = Circle::Color::LIGHT_BLUE;
            break;
        }
        case 6: {
            color = Circle::Color::BLUE;
            break;
        }
        case 7: {
            color = Circle::Color::VIOLET;
            break;
        }
        default: {
            color = Circle::Color::RED;
            break;
        }
    }
    fprintf(input_rnd, "CIRCLE %d %d %d %s \n", x, y, rad, ColorToString(color).c_str());
}

void Circle::Out(FILE *output_file) {
    printf("Circle: (%d; %d); radius = %d; Color = %s; \n Perimeter = %lf \n",
          x, y, rad, ColorToString(color).c_str(), Perimeter());
    fprintf(output_file, "Circle: (%d; %d); radius = %d; Color = %s; \n Perimeter = %lf \n",
            x, y, rad, ColorToString(color).c_str(), Perimeter());
}

double Circle::Perimeter() {
    return 2 * M_PI * rad;
}

std::string Circle::ColorToString(Color color) {
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

Circle::Color Circle::GetColor(char color_type[10001]) {
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

