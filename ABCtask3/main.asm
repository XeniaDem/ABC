;------------------------------------------------------------------------------
; main.asm - содержит главную функцию,
; обеспечивающую простое тестирование
;------------------------------------------------------------------------------
; main.asm

global  RECTANGLE
global  TRIANGLE
global  CIRCLE

%include "macros.mac"

section .data
    RECTANGLE   dd  1
    TRIANGLE    dd  2
    CIRCLE      dd  3
    oneDouble   dq  1.0
    erMsg1  db "Incorrect number of arguments = %d: ",10,0
    rndGen  db "-n",0
    fileGen  db "-f",0
    errMessage1 db  "incorrect command line!", 10,"  Waited:",10
                db  "     command -f infile outfile01 outfile02",10,"  Or:",10
                db  "     command -n number outfile01 outfile02",10,0
    errMessage2 db  "incorrect qualifier value!", 10,"  Waited:",10
                db  "     command -f infile outfile01 outfile02",10,"  Or:",10
                db  "     command -n number outfile01 outfile02",10,0
    len         dd  0           ; Количество элементов в массиве
    intfmt      db  "%d",0
    rndFileName db  "RndInput.txt",0 ; имя создаваемого файла при рандомной генерации
section .bss
    argc        resd    1
    num         resd    1
    sum         resq    1
    start       resq    1       ; начало отсчета времени
    delta       resq    1       ; интервал отсчета времени
    startTime   resq    2       ; начало отсчета времени
    endTime     resq    2       ; конец отсчета времени
    deltaTime   resq    2       ; интервал отсчета времени
    ifst        resq    1       ; указатель на файл, открываемый файл для чтения фигур
    ofst1       resq    1       ; указатель на файл, открываемый файл для записи контейнера
    ofst2       resq    1       ; указатель на файл, открываемый файл для записи периметра
    ofrnd       resq    1       ; указатель на файл, создаваемый при рандомной генерации фигур
    cont        resb    480000  ; Массив используемый для хранения данных

section .text
    global main
main:
push rbp
mov rbp,rsp

    mov dword [argc], edi ;rdi contains number of arguments
    mov r12, rdi ;rdi contains number of arguments
    mov r13, rsi ;rsi contains the address to the array of arguments

    cmp r12, 5      ; проверка количества аргументов
    je .next1
    PrintStrBuf errMessage1, [stdout]
    jmp .return
.next1:
    PrintStrLn "Start", [stdout]
    ; Проверка второго аргумента
    mov rdi, rndGen
    mov rsi, [r13+8]    ; второй аргумент командной строки
    call strcmp
    cmp rax, 0          ; строки равны "-n"
    je .next2
    mov rdi, fileGen
    mov rsi, [r13+8]    ; второй аргумент командной строки
    call strcmp
    cmp rax, 0          ; строки равны "-f"
    je .next3
    PrintStrBuf errMessage2, [stdout]
    jmp .return
.next2:
    ; Генерация случайных фигур
    mov rdi, [r13+16]
    call atoi
    mov [num], eax
    cmp eax, 1
    jl .fall1
    cmp eax, 10000
    jg .fall1
    ; Начальная установка генератора случайных чисел
    xor     rdi, rdi
    xor     rax, rax
    call    time
    mov     rdi, rax
    xor     rax, rax
    call    srand
    ; Заполнение контейнера случайными фигурами
    mov     rdi, cont   ; передача адреса контейнера
    mov     rsi, len    ; передача адреса для длины
    mov     edx, [num]  ; передача количества порождаемых фигур
    call    InRndContainer

    ; Печать созданного контейнера в отдельный файл
    FileOpen rndFileName, "w", ofrnd
    PrintRndContainer cont, [num], [ofrnd]
    FileClose [ofrnd]

    mov     rdi, cont
    jmp .task2

.next3:
    ; Получение фигур из файла
    FileOpen [r13+16], "r", ifst
    ; Читаем общее число фигур в файле
    mov rdi, [ifst]
    mov rsi, intfmt
    mov rdx, num
    xor rax, rax
    call fscanf

    mov eax, [num]
    cmp eax, 1
    jl .fall1
    cmp eax, 10000
    jg .fall1
    ; Заполнение контейнера фигурами из файла
    mov     rdi, cont           ; адрес контейнера
    mov     rsi, len            ; адрес для установки числа элементов
    mov     rdx, [ifst]         ; указатель на файл
    xor     rax, rax
    call    InContainer         ; ввод данных в контейнер
    FileClose [ifst]

.task2:



    ; Вычисление времени старта
    mov rax, 228   ; 228 is system call for sys_clock_gettime
    xor edi, edi   ; 0 for system clock (preferred over "mov rdi, 0")
    lea rsi, [startTime]
    syscall        ; [time] contains number of seconds
                   ; [time + 8] contains number of nanoseconds

    ;сумму периметров считать не требуется
    ;ContainerSum cont, [len], [sum]

    mov rdi, cont
    mov rsi, [len]
    call InsertionSort

    ; Вычисление времени завершения
    mov rax, 228   ; 228 is system call for sys_clock_gettime
    xor edi, edi   ; 0 for system clock (preferred over "mov rdi, 0")
    lea rsi, [endTime]
    syscall        ; [time] contains number of seconds
                   ; [time + 8] contains number of nanoseconds

        ; Вывод содержимого контейнера
    PrintStr "Total number of shapes is ", [stdout]
    PrintInt [len], [stdout]
    PrintStrLn " ", [stdout]
    PrintStrLn "Shapes are:", [stdout]
    PrintContainer cont, [len], [stdout]

    FileOpen [r13+24], "w", ofst1
    PrintStr "Total number of shapes is ", [ofst1]
    PrintInt [len], [ofst1]
    PrintStrLn " ", [ofst1]
    PrintStrLn "Shapes are:", [ofst1]
    PrintContainer cont, [len], [ofst1]
    FileClose [ofst1]

    ; Получение времени работы
    mov rax, [endTime]
    sub rax, [startTime]
    mov rbx, [endTime+8]
    mov rcx, [startTime+8]
    cmp rbx, rcx
    jge .subNanoOnly
    ; иначе занимаем секунду
    dec rax
    add rbx, 1000000000
.subNanoOnly:
    sub rbx, [startTime+8]
    mov [deltaTime], rax
    mov [deltaTime+8], rbx

    ; Вывод периметра нескольких фигур
    ; сумму периметров считать не требуется
    ;PrintStr "Perimeter sum = ", [stdout]
    ;PrintDouble [sum], [stdout]
    PrintStr "Calculaton time = ", [stdout]
    PrintLLUns [deltaTime], [stdout]
    PrintStr " sec, ", [stdout]
    PrintLLUns [deltaTime+8], [stdout]
    PrintStr " nsec", [stdout]
    PrintStr 10, [stdout]

    FileOpen [r13+32], "w", ofst2
    ;сумму периметров считать не требуется
    ;PrintStr  "Perimeter sum = ", [ofst2]
    ;PrintDouble [sum], [ofst2]
    PrintStr "Calculaton time = ", [ofst2]
    PrintLLUns [deltaTime], [ofst2]
    PrintStr " sec, ", [ofst2]
    PrintLLUns [deltaTime+8], [ofst2]
    PrintStr " nsec", [ofst2]
    PrintStr 10, [ofst2]
    FileClose [ofst2]

    PrintStrLn "Stop", [stdout]
    jmp .return
.fall1:
    PrintStr "incorrect number of figures = ", [stdout]
    PrintInt [num], [stdout]
    PrintStrLn ". Set 0 < number <= 10000", [stdout]
.return:
leave
ret
