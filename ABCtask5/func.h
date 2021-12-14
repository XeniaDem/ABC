//
// Created by Ксения Демиденко on 14.12.2021.
//

#ifndef ABCTASK5_FUNC_H
#define ABCTASK5_FUNC_H

#include <sstream>
#include <vector>
#include "rnd.h"

// Класс ограничивающей функции.
class Func {
protected:
    // Для случайной генерации коэффициентов функции.
    static Random rnd1000;
    static Random rnd7;
private:
    // Результат вычисления функции.
    double result = 0;

    // Строковое представление функции.
    std::string funcString;

    // Коэффициенты функции.
    std::vector<double> coefficients;
public:
    // Получение функции из входного файла.
    void getFromFile(const std::string& input_data);

    // Генерация случайной функции.
    void generateRandomFunc();

    // Вычисление значения от функции.
    double f(double x);

    // Строковое представление функции.
    std::string toString() const;
};

#endif //ABCTASK5_FUNC_H