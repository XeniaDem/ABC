//
// Created by Ксения Демиденко on 14.12.2021.
//

#include "integrate.h"
#include "rnd.h"
#include "func.h"
#include <utility>

// Описание методов класса Integrate.
Random Integrate::rnd100(-100, 100);

void Integrate::generateRandomBounds() {
    double west, east;
    while (west >= east) {
        west = rnd100.getDouble();
        east = rnd100.getDouble();
    }
    setBounds(west, east);
}

void Integrate::setBounds(double west, double east) {
    this->west_bound = west;
    this->east_bound = east;
}

Integrate::Integrate(Func func) {
    this->function = std::move(func);

}
std::pair<double, double> Integrate::getBounds() {
    return {west_bound, east_bound};
}

Func Integrate::getFunction() const {
    return function;
}
