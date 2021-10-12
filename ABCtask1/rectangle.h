#ifndef __rectangle__
#define __rectangle__

//------------------------------------------------------------------------------
// rectangle.h - содержит описание прямоугольника  и его интерфейса
//------------------------------------------------------------------------------

#include <fstream>
#include <iostream>
// Прямоугольник
struct Rectangle
{
    int x_up_left, y_up_left;       // координаты левого верхнего угла
    int x_down_right, y_down_right; // координаты правого нижнего угла

    //------------------------------------------------------------------------------
    // Цвета прямоугольника
    enum Color
    {
        RED,
        ORANGE,
        YELLOW,
        GREEN,
        LIGHT_BLUE,
        BLUE,
        VIOLET,
    } color;

    //------------------------------------------------------------------------------
    // Ввод параметров прямоугольника из файла
    int In(FILE *input_file);

    //------------------------------------------------------------------------------
    // Вывод параметров прямоугольника в форматируемый поток
    void Out(FILE *output_file);

    //------------------------------------------------------------------------------
    // Вычисление периметра прямоугольника
    double Perimeter();

    //------------------------------------------------------------------------------
    // Представление цвета прямоугольника в строковом формате
    std::string ColorToString(Color color);

    //------------------------------------------------------------------------------
    // Получение цвета прямоугольника из строки
    Color GetColor(char color_type[10001]);
};

#endif //__rectangle__