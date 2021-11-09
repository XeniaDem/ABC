import sys
import container
import time


# Error message
def err_message1():
    print("Incorrect input data!\n"
          "For getting data from existing file enter \"python main.py <input_file> <output_file>\"\n"
          "For random generation enter \"python main.py <random_input_data_file> <output_file> <number_of_elements>\"")


# Main entry of the program
if __name__ == "__main__":
    start_time = time.time()
    if len(sys.argv) == 3:  # Data from existing file
        try:
            input_file = open(sys.argv[1], "r")
        except IOError:
            print("Cannot open the input file!")
            sys.exit(1)
        output_file = open(sys.argv[2], 'w')
        container = container.Container()
        container.container_in(input_file)
        input_file.close()
        container.container_sort_elements()
        container.container_out(output_file)
        output_file.close()
    elif len(sys.argv) == 4:  # Randomly generated data
        try:
            size = int(sys.argv[3])
        except ValueError:
            print("Incorrect input in the command line!")
            sys.exit(1)
        input_rnd_file = open(sys.argv[1], 'w')
        container = container.Container()
        container.container_in_rnd(size, input_rnd_file)
        output_file = open(sys.argv[2], 'w')
        input_rnd_file.close()
        container.container_sort_elements()
        container.container_out(output_file)
        output_file.close()
    else:  # Error
        err_message1()
        sys.exit(1)
    print("Working time: " + str(time.time() - start_time))

