; file.asm - использование файлов в NASM
extern fprintf

extern RECTANGLE
extern TRIANGLE
extern CIRCLE

;----------------------------------------------
;// Вывод параметров рандомно сгенерированного прямоугольника в файл
;void OutRndRectangle(void *r, FILE *ofst) {
;    fprintf(ofst, "1 %d %d %d %d ", *((int*)r), *((int*)(r+intSize)),
;            *((int*)(r+2*intSize)), *((int*)(r+3*intSize)));
;    fprintf(ofst, "%s\n", (char*)(r+4*intSize+doubleSize));
;}
global OutRndRectangle
OutRndRectangle:
section .data
    .outfmt1 db "1 %d %d %d %d ",0
    .outfmt2 db "%s",10,0
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
    add     rdx, 24             ; адрес хранения цвета = 4*intSize+doubleSize

    xor     rax, rax            ; нет чисел с плавающей точкой
    call    fprintf

leave
ret

;----------------------------------------------
; // Вывод параметров рандомно сгенерированного треугольника в файл
; void OutRndTriangle(void *t, FILE *ofst) {
;     fprintf(ofst, "2 %d %d %d %d ",
;           *(int*)t), *((int*)(t+intSize)), *((int*)(t+2*intSize), *((int*)(t+3*intSize)));
;     fprintf(ofst, "%d %d %s\n", *((int*)(t+4*intSize)),
;           *((int*)(t+5*intSize)), (char*)(t+6*intSize+doubleSize));
; }
global OutRndTriangle
OutRndTriangle:
section .data
    .outfmt1 db "2 %d %d %d %d ",0
    .outfmt2 db "%d %d %s",10,0
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
    mov     rax, 0              ; нет чисел с плавающей точкой
    call    fprintf

leave
ret

;----------------------------------------------
; // Вывод параметров рандомно сгенерированного круга в файл
; void OutRndCircle(void *t, FILE *ofst) {
;     fprintf(ofst, "3 %d %d %d %s\n", *((int*)t), *((int*)(t+intSize)),
;            *((int*)(t+2*intSize)), (char*)(t+3*intSize+doubleSize));
; }
global OutRndCircle
OutRndCircle:
section .data
    .outfmt db "3 %d %d %d %s",10,0
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
    xor     rax, rax            ; нет чисел с плавающей точкой
    call    fprintf

leave
ret

;----------------------------------------------
; // Вывод параметров текущей фигуры в файл
; void OutRndShape(void *s, FILE *ofst) {
;     int k = *((int*)s);
;     if(k == RECTANGLE) {
;         OutRndRectangle(s+intSize, ofst);
;     }
;     else if(k == TRIANGLE) {
;         OutRndTriangle(s+intSize, ofst);
;     }
;     else if(k == CIRCLE) {
;         OutRndCircle(s+intSize, ofst);
;     }
;     else {
;         fprintf(ofst, "Incorrect figure!\n");
;     }
; }
global OutRndShape
OutRndShape:
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
    call    OutRndRectangle
    jmp     return
trianOut:
    ; Вывод треугольника
    add     rdi, 4
    call    OutRndTriangle
    jmp     return
circOut:
    ; Вывод круга
    add     rdi, 4
    call    OutRndCircle
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
global OutRndContainer
OutRndContainer:
section .data
    numFmt  db  "%d",10,0
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
    mov rbx, rsi        ; число фигур


; Вывод общего количества фигур
    mov     rdi, [.FILE]    ; текущий указатель на файл
    mov     rsi, numFmt     ; формат для вывода
    mov     edx, [.len]     ; число элементов контейнера
    xor     rax, rax,       ; только целочисленные регистры
    call fprintf

    xor ecx, ecx        ; счетчик фигур = 0

.loop:
    cmp ecx, ebx        ; проверка на окончание цикла
    jge .return         ; Перебрали все фигуры

    push rbx
    push rcx

    ; Вывод текущей фигуры
    mov     rdi, [.pcont]
    mov     rsi, [.FILE]
    call OutRndShape           ; Вывод фигуры

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
