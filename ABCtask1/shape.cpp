//------------------------------------------------------------------------------
// shape.h - содержит описание обобщающей геометрической фигуры,
//------------------------------------------------------------------------------

#include "shape.h"
#include <cstring>
#include <fstream>

int Shape::GetIntType(char str_type[10001])
{
    if (strcmp(str_type, "CIRCLE") == 0)
    {
        return 0;
    }
    if (strcmp(str_type, "RECTANGLE") == 0)
    {
        return 1;
    }
    if (strcmp(str_type, "TRIANGLE") == 0)
    {
        return 2;
    }
    return -1;
}

int Shape::In(FILE *input_file)
{
    int type;
    char str_type[10002];
    fscanf(input_file, "%10000s", str_type);
    switch (GetIntType(str_type))
    {
    case CIRCLE:
        shape_type = CIRCLE;
        return circle.In(input_file);
    case RECTANGLE:
        shape_type = RECTANGLE;
        return rectangle.In(input_file);
    case TRIANGLE:
        shape_type = TRIANGLE;
        return triangle.In(input_file);

    default:
        printf("Could not parse number type\n");
        return 1;
    }
}

void Shape::Out(FILE *output_file)
{
    switch (shape_type)
    {
    case 0:
        return circle.Out(output_file);
    case 1:
        return rectangle.Out(output_file);
    case 2:
        return triangle.Out(output_file);
    default:
        return;
    }
}

double Shape::Perimeter()
{
    switch (shape_type)
    {
    case CIRCLE:
        return circle.Perimeter();
    case RECTANGLE:
        return rectangle.Perimeter();
    case TRIANGLE:
        return triangle.Perimeter();
    default:
        return 0.0;
    }
}
