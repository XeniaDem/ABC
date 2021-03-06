#ifndef __container__
#define __container__

//------------------------------------------------------------------------------
// container.h - содержит описание контейнера и его интерфейса
//------------------------------------------------------------------------------

#include "shape.h"
#include <fstream>
#include <cstdlib>

// Контейнер
class Container {
public:
    int size{0};
    //------------------------------------------------------------------------------
    // Ввод содержимого контейнера из файла
    void In(FILE* input_file);

    //------------------------------------------------------------------------------
    // Случайный ввод содержимого контейнера
    void InRnd(int size, FILE *input_rnd);

    //------------------------------------------------------------------------------
    // Вывод содержимого контейнера в файл
    void Out(FILE* output_file);

    //------------------------------------------------------------------------------
    // Сортировка элементов контейнера
    void SortElements();
private:
    //------------------------------------------------------------------------------
    // Содержимое контейнера
    Shape *content[10001];
};
#endif //__container__