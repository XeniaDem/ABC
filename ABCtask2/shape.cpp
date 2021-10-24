//------------------------------------------------------------------------------
// shape.h - содержит описание обобщающей геометрической фигуры,
//------------------------------------------------------------------------------

#include "rnd.h"
#include "circle.h"
#include "rectangle.h"
#include "triangle.h"
#include <cstring>
#include <iostream>

Random Shape::rnd1000(1, 1000);
Random Shape::rnd3(1, 3);
Random Shape::rnd7(1, 7);

int Shape::GetIntType(char str_type[10001]) {
    if (strcmp(str_type, "CIRCLE") == 0)
        return 0;
    if (strcmp(str_type, "RECTANGLE") == 0) 
        return 1;
    if (strcmp(str_type, "TRIANGLE") == 0) 
        return 2;
    return -1;
}

Shape* Shape::StaticIn(FILE *input_file) {
    char str_type[10001];
    fscanf(input_file, "%10000s", str_type);
    switch (GetIntType(str_type)) {
        case 0: {
            Circle *c = new Circle;
            c->In(input_file);
            return c;
        } 
        case 1: {
            Rectangle *r = new Rectangle;
            r->In(input_file);
            return r;
        } 
        case 2: {
            Triangle *t = new Triangle;
            t->In(input_file);
            return t;
        }
    }
    return nullptr;
}

Shape* Shape::StaticInRnd(FILE *input_rnd) {
    int k = rnd3.Get();
    switch(k) {
        case 1: {
            Circle *c = new Circle;
            c->InRnd(input_rnd);
            return c;
        }
        case 2: {
            Rectangle *r = new Rectangle;
            r->InRnd(input_rnd);
            return r;
        }
        case 3: {
            Triangle *t = new Triangle;
            t->InRnd(input_rnd);
            return t;
        }
    }
}
