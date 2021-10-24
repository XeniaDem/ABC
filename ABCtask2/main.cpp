#include <fstream>
#include <time.h>
#include "container.h"
#include <unistd.h>

// Сообщение об ошибке
void errMessage1() {
    printf("Incorrect input data!\n");
}
//------------------------------------------------------------------------------
// Получение входного файла
FILE *get_input_file(char *argv[])
{
    if (access(argv[1], F_OK) != -1)
        return fopen(argv[1], "r");
    else
        printf("File does not exist!\n");
    exit(1);
}

//------------------------------------------------------------------------------
// Получение выходного файла
FILE *get_output_file(char *argv[]) {
    if (access(argv[2], F_OK) != -1)
        return fopen(argv[2], "w");
    else
        printf("Could not open file!\n");
    exit(1);
}

FILE *get_input_rnd(char *argv[]) {
    if (access(argv[1], F_OK) != -1)
        return fopen(argv[1], "w");
    else
        printf("Could not open file!\n");
    exit(1);
}

//------------------------------------------------------------------------------
// Точка входа в программу
int main(int argc, char *argv[]) {
    time_t start, end;
    start = clock();
    if (argc != 3) {
        if (argc == 4) { // Случай рандомной генерации
            int size = atoi(argv[3]);
            Container container;
            FILE *input_rnd = get_input_rnd(argv);

            container.InRnd(size, input_rnd);
            FILE *output_file = get_output_file(argv);
            container.SortElements();
            container.Out(output_file);
            return 0;
        }
        errMessage1();
        return 1;
    }
    Container container;
    FILE *input_file = get_input_file(argv);
    container.In(input_file);
    fclose(input_file);
    FILE *output_file = get_output_file(argv);
    container.SortElements();
    container.Out(output_file);
    fclose(output_file);
    end = clock();
    printf("Прошло времени с момента запуска: %f\n", difftime(end, start) / CLOCKS_PER_SEC);
    return 0;
}