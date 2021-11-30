; file.asm - использование файлов в NASM
extern printf
extern fprintf

extern RECTANGLE
extern TRIANGLE
extern CIRCLE

;----------------------------------------------
;// Вывод параметров прямоугольника в файл
;void OutRectangle(void *r, FILE *ofst) {
;    fprintf(ofst, "Rectangle, x_up_left = %d, y_up_left = %d, x_down_right = %d,
;            y_down_right = %d, ", *((int*)r), *((int*)(r+intSize)),
;            *((int*)(r+2*intSize)), *((int*)(r+3*intSize)));
;    fprintf(ofst, "perimeter = %g, color = %s\n", *((double*)(r+4*intSize)),
;               (char*)(r+4*intSize+doubleSize));
;}
global OutRectangle
OutRectangle:
section .data
    .outfmt1 db "Rectangle, x_up_left = %d, y_up_left = %d, x_down_right = %d, y_down_right = %d, ",0
    .outfmt2 db "perimeter = %g, color = %s",10,0
section .bss
    .prect  resq  1       ; адрес прямоугольника
    .FILE   resq  1       ; временное хранение указателя на файл
section .text
push rbp
mov rbp, rsp

    ; Сохранение принятых аргументов
    mov     [.prect], rdi         ; сохраняется адрес прямоугольника
    mov     [.FILE], rsi          ; сохраняется указатель на файл

    ; Вывод информации о прямоугольнике в файл
    mov     rdi, [.FILE]
    mov     rsi, .outfmt1       ; Формат строки - 2-й аргумент
    mov     rax, [.prect]       ; адрес прямоугольника
    mov     edx, [rax]          ; x_up_left
    mov     ecx, [rax+4]        ; y_up_left
    mov      r8, [rax+8]        ; x_down_right
    mov      r9, [rax+12]       ; y_down_right
    xor     rax, rax            ; нет чисел с плавающей точкой
    call    fprintf

    mov     rdi, [.FILE]        ;
    mov     rsi, .outfmt2       ; Формат - 2-й аргумент
    mov     rdx, [.prect]       ; адрес прямоугольника
    movsd   xmm0, [rdx+16]
    add     rdx, 24             ; адрес хранения цвета = 4*intSize+doubleSize

    mov     rax, 1              ; есть числа с плавающей точкой
    call    fprintf

leave
ret

;----------------------------------------------
; // Вывод параметров треугольника в файл
; void OutTriangle(void *t, FILE *ofst) {
;     fprintf(ofst, "Triangle, x1 = %d, y1 = %d, x2 = %d, y2 = %d, ",
;           *(int*)t), *((int*)(t+intSize)), *((int*)(t+2*intSize), *((int*)(t+3*intSize)));
;     fprintf(ofst, "x3 = %d, y3 = %d, perimeter = %g, color = %s\n", *((int*)(t+4*intSize)),
;           *((int*)(t+5*intSize)), *((double*)(t+6*intSize)), (char*)(t+6*intSize+doubleSize));
; }
global OutTriangle
OutTriangle:
section .data
    .outfmt1 db "Triangle, x1 = %d, y1 = %d, x2 = %d, y2 = %d, ",0
    .outfmt2 db "x3 = %d, y3 = %d, perimeter = %g, color = %s",10,0
section .bss
    .ptrian  resq  1      ; адрес треугольника
    .FILE   resq  1       ; временное хранение указателя на файл
section .text
push rbp
mov rbp, rsp

    ; Сохранение принятых аргументов
    mov     [.ptrian], rdi        ; сохраняется адрес треугольника
    mov     [.FILE], rsi          ; сохраняется указатель на файл

    ; Вывод информации о треугольнике в файл
    mov     rdi, [.FILE]
    mov     rsi, .outfmt1       ; Формат - 2-й аргумент
    mov     rax, [.ptrian]      ; адрес треугольника
    mov     edx, [rax]          ; x1
    mov     ecx, [rax+4]        ; y1
    mov      r8, [rax+8]        ; x2
    mov      r9, [rax+12]       ; y2
    mov     rax, 0              ; нет чисел с плавающей точкой
    call    fprintf

    mov     rdi, [.FILE]
    mov     rsi, .outfmt2       ; Формат - 2-й аргумент
    mov     rax, [.ptrian]      ; адрес треугольника
    mov     edx, [rax+16]       ; x3
    mov     ecx, [rax+20]       ; y3
    lea      r8, [rax+32]       ; адрес хранения цвета = 6*intSize+doubleSize
    movsd   xmm0,[rax+24]
    mov     rax, 1              ; есть числа с плавающей точкой
    call    fprintf

leave
ret

;----------------------------------------------
; // Вывод параметров круга в файл
; void OutCircle(void *t, FILE *ofst) {
;     fprintf(ofst, "Circle, x = %d, y = %d, radius = %d, perimeter = %g, color = %s\n",
;            *((int*)t), *((int*)(t+intSize)), *((int*)(t+2*intSize)),
;             *((double*)(t+3*intSize)), (char*)(t+3*intSize+doubleSize));
; }
global OutCircle
OutCircle:
section .data
    .outfmt db "Circle, x = %d, y = %d, radius = %d, perimeter = %g, color = %s",10,0
section .bss
    .pcirc resq  1         ; адрес круга
    .FILE    resq  1       ; временное хранение указателя на файл
section .text
push rbp
mov rbp, rsp

    ; Сохранение принятых аргументов
    mov     [.pcirc], rdi        ; сохраняется адрес круга
    mov     [.FILE], rsi         ; сохраняется указатель на файл

    ; Вывод информации о круге в файл
    mov     rdi, [.FILE]
    mov     rsi, .outfmt        ; Формат - 2-й аргумент
    mov     rax, [.pcirc]       ; адрес круга
    mov     edx, [rax]          ; x
    mov     ecx, [rax+4]        ; y
    mov      r8, [rax+8]        ; radius
    lea      r9, [rax+20]       ; адрес хранения цвета = 3*intSize+doubleSize
    movsd   xmm0, [rax+12]
    mov     rax, 1              ; есть числа с плавающей точкой
    call    fprintf

leave
ret

;----------------------------------------------
; // Вывод параметров текущей фигуры в файл
; void OutShape(void *s, FILE *ofst) {
;     int k = *((int*)s);
;     if(k == RECTANGLE) {
;         OutRectangle(s+intSize, ofst);
;     }
;     else if(k == TRIANGLE) {
;         OutTriangle(s+intSize, ofst);
;     }
;     else if(k == CIRCLE) {
;         OutCircle(s+intSize, ofst);
;     }
;     else {
;         fprintf(ofst, "Incorrect figure!\n");
;     }
; }
global OutShape
OutShape:
section .data
    .erShape db "Incorrect figure!",10,0
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес фигуры
    mov eax, [rdi]
    cmp eax, [RECTANGLE]
    je rectOut
    cmp eax, [TRIANGLE]
    je trianOut
    cmp eax, [CIRCLE]
    je circOut
    mov rdi, .erShape
    mov rax, 0
    call fprintf
    jmp     return
rectOut:
    ; Вывод прямоугольника
    add     rdi, 4
    call    OutRectangle
    jmp     return
trianOut:
    ; Вывод треугольника
    add     rdi, 4
    call    OutTriangle
    jmp     return
circOut:
    ; Вывод круга
    add     rdi, 4
    call    OutCircle
return:
leave
ret

;----------------------------------------------
; // Вывод содержимого контейнера в файл
; void OutContainer(void *c, int len, FILE *ofst) {
;     void *tmp = c;
;     fprintf(ofst, "Container contains %d elements.\n", len);
;     for(int i = 0; i < len; i++) {
;         fprintf(ofst, "%d: ", i);
;         OutShape(tmp, ofst);
;         tmp = tmp + shapeSize;
;     }
; }
global OutContainer
OutContainer:
section .data
    numFmt  db  "%d: ",0
section .bss
    .pcont  resq    1   ; адрес контейнера
    .len    resd    1   ; адрес для сохранения числа введенных элементов
    .FILE   resq    1   ; указатель на файл
section .text
push rbp
mov rbp, rsp

    mov [.pcont], rdi   ; сохраняется указатель на контейнер
    mov [.len],   esi   ; сохраняется число элементов
    mov [.FILE],  rdx   ; сохраняется указатель на файл

    ; В rdi адрес начала контейнера
    mov rbx, rsi        ; число фигур
    xor ecx, ecx        ; счетчик фигур = 0
    mov rsi, rdx        ; перенос указателя на файл
.loop:
    cmp ecx, ebx        ; проверка на окончание цикла
    jge .return         ; Перебрали все фигуры

    push rbx
    push rcx

    ; Вывод номера фигуры
    mov     rdi, [.FILE]    ; текущий указатель на файл
    mov     rsi, numFmt     ; формат для вывода фигуры
    mov     edx, ecx        ; индекс текущей фигуры
    xor     rax, rax,       ; только целочисленные регистры
    call fprintf

    ; Вывод текущей фигуры
    mov     rdi, [.pcont]
    mov     rsi, [.FILE]
    call OutShape           ; Вывод фигуры

    pop rcx
    pop rbx
    inc ecx                 ; индекс следующей фигуры

    mov     rax, [.pcont]
    add     rax, 48         ; адрес следующей фигуры
    mov     [.pcont], rax
    jmp .loop
.return:
leave
ret
