
#include <fstream>
#include <cmath>
#include <cstring>
#include "circle.h"

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

void Circle::Out(FILE *output_file)
{
    printf("Circle: (%d; %d); radius = %d; Color = %s; \n Perimeter = %lf \n",
          x, y, rad, ColorToString(color).c_str(), Perimeter());
    fprintf(output_file, "Circle: (%d; %d); radius = %d; Color = %s; \n Perimeter = %lf \n",
            x, y, rad, ColorToString(color).c_str(), Perimeter());
}

double Circle::Perimeter()
{
    return 2 * M_PI * rad;
}

std::string Circle::ColorToString(Color color)
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

Circle::Color Circle::GetColor(char color_type[10001])
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
    return RED;
}
