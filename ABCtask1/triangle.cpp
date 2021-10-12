#include <fstream>
#include <cmath>
#include <cstring>
#include "triangle.h"
#include <iostream>
int Triangle::In(FILE *input_file)
{
    char color_type[10001];
    int res = fscanf(input_file, "%d %d %d %d %d %d %10000s", &x1, &y1, &x2, &y2, &x3, &y3, color_type);
    if (res != 7)
    {
        std::cout<<x1<<y1<<std::endl;
        printf("Could not read string\n");
        return 1;
    }
    color = GetColor(color_type);
    return 0;
}

void Triangle::Out(FILE *output_file)
{
    printf("Triangle: (%d; %d); (%d; %d); (%d; %d); Color = %s;\n Perimeter = %lf \n",
          x1, y1, x2, y2, x3, y3, ColorToString(color).c_str(), Perimeter());
    fprintf(output_file, "Triangle: (%d; %d); (%d; %d); (%d; %d); Color = %s;\n Perimeter = %lf \n",
            x1, y1, x2, y2, x3, y3, ColorToString(color).c_str(), Perimeter());
}

double Triangle::Perimeter()
{
    return Side(x1, y1, x2, y2) + Side(x1, y1, x3, y3) + Side(x2, y2, x3, y3);
}

double Triangle::Side(int x1, int y1, int x2, int y2)
{
    return sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2));
}
std::string Triangle::ColorToString(Color color)
{
    switch (color)
    {
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

Triangle::Color Triangle::GetColor(char color_type[10001])
{
    if (strcmp(color_type, "RED") == 0)
    {
        return RED;
    }
    if (strcmp(color_type, "ORANGE") == 0)
    {
        return ORANGE;
    }
    if (strcmp(color_type, "YELLOW") == 0)
    {
        return YELLOW;
    }
    if (strcmp(color_type, "GREEN") == 0)
    {
        return GREEN;
    }
    if (strcmp(color_type, "LIGHT_BLUE") == 0)
    {
        return LIGHT_BLUE;
    }
    if (strcmp(color_type, "BLUE") == 0)
    {
        return BLUE;
    }
    if (strcmp(color_type, "VIOLET") == 0)
    {
        return VIOLET;
    }
    return VIOLET;
}
