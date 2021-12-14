//
// Created by Ксения Демиденко on 14.12.2021.
//

#include <vector>
#include <iostream>
#include "func.h"
// Описание методов класса Func.
Random Func::rnd1000(-1000, 1000);
Random Func::rnd7(3, 7);

// Вспомогательный метод быстрого возведения в степень.
double pow(double a, size_t n) {
    return n == 0? 1 : n % 2? a * pow(a, n - 1): pow(a * a, n / 2);
}

void Func::getFromFile(const std::string& input) {
    std::istringstream input_data(input);
    std::string parameter;
    while (input_data >> parameter) {
        try {
            double coefficient = std::stod(parameter);
            coefficients.push_back(coefficient);
            if (coefficients.size() > 7) {
                std::cout << "Too long function in current file. Number of coefficients should not more than 7." << std::endl;
                exit(0);
            }
        } catch (const std::exception& exception) {
            std::cout << "Wrong format of function in the file! Please try another one or use random generation." << std::endl;
            exit(1);
        }
    }
    for (int i = 0; i < coefficients.size(); ++i) {
        if (i != 0) {
            if (coefficients[i] >= 0) {
                funcString += " +";
            } else{
                funcString += " ";
            }
        }
        funcString += std::to_string(coefficients[i])+ "x^" + std::to_string(coefficients.size() - i - 1);
    }
}

void Func::generateRandomFunc() {
    int terms_num = rnd7.getInt();
    for (int i = 0; i < terms_num; ++i) {
        auto coefficient = (double) rnd1000.getDouble();
        coefficients.push_back(coefficient);
    }
    for (int i = 0; i < coefficients.size(); ++i) {
        if (i != 0) {
            if (coefficients[i] >= 0) {
                funcString += " +";
            } else {
                funcString += " ";
            }
        }
        funcString += std::to_string(coefficients[i])+ "x^" + std::to_string(coefficients.size() - i - 1);
    }
}

double Func::f(double x) {
    for (int i = 0; i < coefficients.size(); ++i) {
        result += coefficients[i] * pow(x, coefficients.size() - i - 1);
    }
    return result;
}

std::string Func::toString() const {
    return funcString;
}
