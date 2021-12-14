#include <iostream>
#include <fstream>
#include "thread"
#include "func.h"
#include "integrate.h"

// Ограничивающая функция для вычислений.
double f(double x, Func func) {
    return func.f(x);
}
// Рекурсивное вычисление интеграла методом адаптивной квадратуры.
void quad(Func func, double left, double right, double func_left, double func_right, double left_right_area, double &res, int &depth) {
    depth++;
    double mid = (left + right) / 2;
    double func_mid = f(mid, func);
    double left_area = (func_left + func_mid) * (mid - left) / 2;
    double right_area = (func_mid+func_right) * (right - mid) / 2;
    if (std::abs((left_area + right_area) - left_right_area) > 1e-4) {
        if (depth < 5) {
            std::thread t1(quad, func, left, mid, func_left, func_mid, left_area, std::ref(left_area), std::ref(depth));
            std::thread t2(quad, func, mid, right, func_mid, func_right, right_area, std::ref(right_area), std::ref(depth));
            t1.join();
            t2.join();
        } else {
            quad(func, left, mid, func_left, func_mid, left_area, std::ref(left_area), std::ref(depth));
            quad(func, mid, right, func_mid, func_right, right_area, std::ref(right_area), std::ref(depth));
        }
    }
    res = left_area + right_area;
}

// Точка входа в программу.
int main(int argc, char* argv[]) {
    time_t start, end;
    start = clock();
    std::string str;
    if (argc == 4) { // Функция и границы из командной строки.
        std::ifstream in(argv[1]);
        if (in.is_open()) {
            std::cout << "Reading function from file..." << std::endl;
            std::getline(in, str);
            Func func;
            func.getFromFile(str);
            std::cout << "Your function is: \n" + func.toString() << std::endl;
            std::cout << "Getting bounds from command line..." << std::endl;
            double west_bound;
            double east_bound;
            try {
                west_bound = std::stod(argv[2]);
                east_bound = std::stod(argv[3]);
                if (west_bound >= east_bound || std::abs(west_bound) > 100 || std::abs(east_bound) > 100) {
                    std::cout << "Incorrect bounds! Right bound should be bigger than left.\n"
                                 "Both bounds should be between -100 and 100." << std::endl;
                    exit(1);
                }
            } catch (std::exception& exception) {
                std::cout << "Incorrect left or right bound! Bounds should be doubles.\n"
                             "Right bound should be bigger than left.\n"
                             "Both bounds should be between -100 and 100." << std::endl;
                exit(1);
            }
            Integrate integrate(func);
            integrate.setBounds(west_bound, east_bound);
            std::cout << "Bounds are from " << integrate.getBounds().first << " to " << integrate.getBounds().second
                      << std::endl;
            std::cout << "Counting area..." << std::endl;
            double area = 0;
            int depth = 0;
            quad(integrate.getFunction(), integrate.getBounds().first, integrate.getBounds().second, func.f(integrate.getBounds().first),
                 func.f(integrate.getBounds().second), (func.f(integrate.getBounds().first) + func.f(integrate.getBounds().second))
                                                       * (integrate.getBounds().second - integrate.getBounds().first) / 2, area, depth);
            std::cout << "The area is " << std::abs(area) << std::endl;
            in.close();
        } else {
            std::cout << "Could not open input file." << std::endl;
            exit(1);
        }
    } else if (argc == 3) { // Рандомная функция, границы из командной строки.
        std::cout << "Generating random function..." << std::endl;
        Func func;
        func.generateRandomFunc();
        std::cout << "Your function is: \n" + func.toString() << std::endl;
        std::cout << "Getting bounds from command line..." << std::endl;
        double west_bound;
        double east_bound;
        try {
            west_bound = std::stod(argv[1]);
            east_bound = std::stod(argv[2]);
            if (west_bound >= east_bound || std::abs(west_bound) > 100 || std::abs(east_bound) > 100) {
                std::cout << "Incorrect bounds! Right bound should be bigger than left.\n"
                             "Both bounds should be between -100 and 100.." << std::endl;
                exit(1);
            }
        } catch (std::exception& exception) {
            std::cout << "Incorrect left or right bound! Bounds should be doubles.\n"
                         "Right bound should be bigger than left.\n"
                         "Both bounds should be between -100 and 100." << std::endl;
            exit(1);
        }
        Integrate integrate(func);
        integrate.setBounds(west_bound, east_bound);
        std::cout << "Bounds are from " << integrate.getBounds().first << " to " << integrate.getBounds().second
                  << std::endl;
        std::cout << "Counting area..." << std::endl;
        double area = 0;
        int depth = 0;
        quad(integrate.getFunction(), integrate.getBounds().first, integrate.getBounds().second, func.f(integrate.getBounds().first),
             func.f(integrate.getBounds().second), (func.f(integrate.getBounds().first) + func.f(integrate.getBounds().second))
                                                   * (integrate.getBounds().second - integrate.getBounds().first) / 2, area, depth);
        std::cout << "The area is " << std::abs(area) << std::endl;
    } else if (argc == 2) { // Функция из файла и рандомная генерация границ.
        std::ifstream in(argv[1]);
        if (in.is_open()) {
            std::cout << "Reading function from file..." << std::endl;
            std::getline(in, str);
            Func func;
            func.getFromFile(str);
            std::cout << "Your function is: \n" + func.toString() << std::endl;
            Integrate integrate(func);
            std::cout << "Generating west and east bounds..." << std::endl;
            integrate.generateRandomBounds();
            std::cout << "Bounds are from " << integrate.getBounds().first << " to " << integrate.getBounds().second
                      << std::endl;
            std::cout << "Counting area..." << std::endl;
            double area = 0;
            int depth = 0;
            quad(integrate.getFunction(), integrate.getBounds().first, integrate.getBounds().second, func.f(integrate.getBounds().first),
                 func.f(integrate.getBounds().second), (func.f(integrate.getBounds().first) + func.f(integrate.getBounds().second))
                                                       * (integrate.getBounds().second - integrate.getBounds().first) / 2, area, depth);
            std::cout << "The area is " << std::abs(area) << std::endl;
            in.close();
        } else {
            std::cout << "Could not open input file." << std::endl;
            exit(1);
        }
    } else if (argc == 1) { // Рандомная генерация функции и границ.
        std::cout << "Generating random function..." << std::endl;
        Func func;
        func.generateRandomFunc();
        std::cout << "Your function is: \n" + func.toString() << std::endl;
        Integrate integrate(func);
        std::cout << "Generating west and east bounds..." << std::endl;
        integrate.generateRandomBounds();
        std::cout << "Bounds are from " << integrate.getBounds().first << " to " << integrate.getBounds().second
                  << std::endl;
        std::cout << "Counting area..." << std::endl;
        double area = 0;
        int depth = 0;
        quad(integrate.getFunction(), integrate.getBounds().first, integrate.getBounds().second, func.f(integrate.getBounds().first),
             func.f(integrate.getBounds().second), (func.f(integrate.getBounds().first) + func.f(integrate.getBounds().second))
                                                   * (integrate.getBounds().second - integrate.getBounds().first) / 2, area, depth);
        std::cout << "The area is " << std::abs(area) << std::endl;
    } else {
        std::cout << "Incorrect command line arguments!\n"
                     "For random function and bounds generation use no parameters.\n"
                     "For random bounds generation and reading function from file write a path to this file as first parameter.\n"
                     "For random function generation and setting bounds by your own write only left and right bounds."
                     "For reading function from file and setting bounds write a path to this file as first parameter \n"
                     "and after that left and right bounds. " << std::endl;
    }
    end = clock();
    printf("Working time: %f\n", difftime(end, start) / CLOCKS_PER_SEC);
}




