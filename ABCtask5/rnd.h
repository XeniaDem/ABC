//
// Created by Ксения Демиденко on 14.12.2021.
//

#ifndef ABCTASK5_RND_H
#define ABCTASK5_RND_H
#include <cstdlib>
#include <ctime>   // для функции time()

//------------------------------------------------------------------------------
// rnd.h - содержит генератор случайных чисел в диапазоне от f до l
//------------------------------------------------------------------------------

class Random {
public:
    // Конструктор, принимает границы диапазона.
    Random(int f, int l) {
        if(f <= l) {
            first = f;
            last = l;
        } else {
            first = l;
            last = f;
        }
        // Системные часы в качестве инициализатора.
        srand(static_cast<unsigned int>(time(nullptr)));
    }
    // Генерация случайного целого числа в заданном диапазоне.
    int getInt() const {
        return rand() % (last - first + 1) + first;
    }
    // Генерация случайного дробного числа в заданном диапазоне.
    double getDouble() const {
        return (double)(rand())/RAND_MAX*(last - first) + first;
    }
private:
    // Границы диапазона.
    int first;
    int last;
};

#endif //ABCTASK5_RND_H
