cmake_minimum_required(VERSION 3.20)
project(main)

set(CMAKE_CXX_STANDARD 17)

file(GLOB SOURCES
     *.cpp)

add_executable(main main.cpp circle.cpp circle.h rectangle.cpp rectangle.h shape.h shape.cpp triangle.h triangle.cpp container.cpp container.h)