//
// Created by Ксения Демиденко on 14.12.2021.
//

#ifndef ABCTASK5_INTEGRATE_H
#define ABCTASK5_INTEGRATE_H

#include "func.h"

// Класс интеграла.
class Integrate {
protected:
    // Для случайной генерации границ вычисления.
    static Random rnd100;
private:
    // Левая граница.
    double west_bound = 0;

    // Правая граница.
    double east_bound = 0;

    // Подынтегральная функция.
    Func function;
public:
    // Конструктор, в качестве аргумента принимает подынтегральную функцию.
    explicit Integrate(Func func);

    // Устанавливает границы вычисления интеграла.
    void setBounds(double west, double east);

    // Случайная генерация границ вычисления интеграла.
    void generateRandomBounds();

    // Получение границ вычисления интеграла.
    std::pair<double, double> getBounds();

    // Получение подынтегральной функции.
    Func getFunction() const;
};

#endif //ABCTASK5_INTEGRATE_H
