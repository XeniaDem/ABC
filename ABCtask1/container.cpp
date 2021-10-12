
#include "shape.h"
#include "container.h"
#include <cstdlib>
#include <iostream>

void Container::In(FILE *input_file)
{
    int count;
    int status_code = fscanf(input_file, "%d\n", &count);
    if (status_code == 1)
    {
        for (int i = 0; i < count; ++i)
        {
            if (size < 10002)
            {
                Shape shape;
                shape.In(input_file);
                content[i] = shape;
                size++;
            }
            else
            {
                printf("Could not add to container\n");
                return;
            }
        }
    }
    else
    {
        printf("Could not parse number!\n");
    }
}

void Container::Out(FILE *output_file)
{
    printf("Container contains %d elements:\n", size);
    fprintf(output_file, "Container contains %d elements:\n", size);
    for (int i = 0; i < size; ++i)
    {
        printf("%d. ", i);
        fprintf(output_file, "%d. ", i);
        content[i].Out(output_file);
    }
}

void Container::SortElements()
{
    for (int i = 1; i < size; i++)
    {
        for (int j = i; j > 0 && content[j - 1].Perimeter() < content[j].Perimeter(); j--)
        {
            std::swap(content[j - 1], content[j]);
        }
    }
}
