#ifndef __rectangle__
#define __rectangle__

//------------------------------------------------------------------------------
// rectangle.h - содержит описание прямоугольника  и его интерфейса
//------------------------------------------------------------------------------

#include <fstream>
#include "shape.h"
// Прямоугольник
class Rectangle: public Shape {
private:
    int x_up_left, y_up_left, x_down_right, y_down_right; // координаты левого верхнего и правого нижнего углов прямоугольника

public:
    //------------------------------------------------------------------------------
    // Ввод параметров прямоугольника из файла
    virtual int In(FILE *input_file);

    //------------------------------------------------------------------------------
    // Рандомная генерация параметров прямоугольника
    virtual void InRnd(FILE *input_rnd);

    //------------------------------------------------------------------------------
    // Вывод параметров прямоугольника в файл
    virtual void Out(FILE *output_file);

    //------------------------------------------------------------------------------
    // Вычисление периметра прямоугольника
    virtual double Perimeter();

    //------------------------------------------------------------------------------
    // Получение цвета прямоугольника из строки
    virtual Color GetColor(char color_type[10001]);

    //------------------------------------------------------------------------------
    // Представление цвета прямоугольника в строковом формате
    virtual std::string ColorToString(Color color);
};

#endif //__rectangle__
