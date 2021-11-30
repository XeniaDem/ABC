extern printf
extern fscanf

extern PerimeterRectangle
extern PerimeterTriangle
extern PerimeterCircle

extern RECTANGLE
extern TRIANGLE
extern CIRCLE

;----------------------------------------------
; // Ввод параметров прямоугольника из файла
; void InRectangle(void *r, FILE *ifst) {
;     fscanf(ifst, "%d%d%d%d",(int*)r, (int*)(r+intSize), (int*)(r+2*intsize), (int*)(r+3*intsize));
;     fscanf(ifst, "%11s", (char*)(r+4*intSize+doubleSize);
;     *((double*)(r+4*intSize) = PerimeterRectangle(r);
; }
global InRectangle
InRectangle:
section .data
    .infmt1 db "%d%d%d%d",0
    .infmt2 db "%11s",0
section .bss
    .FILE   resq    1   ; временное хранение указателя на файл
    .prect  resq    1   ; адрес прямоугольника
section .text
push rbp
mov rbp, rsp

    ; Сохранение принятых аргументов
    mov     [.prect], rdi       ; сохраняется адрес прямоугольника
    mov     [.FILE], rsi        ; сохраняется указатель на файл

    ; Ввод прямоугольника из файла
    mov     rdi, [.FILE]
    mov     rsi, .infmt1        ; Формат входной строки
    mov     rdx, [.prect]       ; &x1
    mov     rcx, [.prect]
    add     rcx, 4              ; &y1 = &x1 + 4
    mov      r8, [.prect]
    add      r8, 8              ; &x2 = &x1 + 8
    mov      r9, [.prect]
    add      r9, 12             ; &y2 = &x1 + 12
    mov     rax, 0              ; нет чисел с плавающей точкой
    call    fscanf

    mov     rdi, [.FILE]
    mov     rsi, .infmt2        ; Формат входной строки
    mov     rdx, [.prect]
    add     rdx, 24             ; color = &x1 + 16 + 8
    mov     rax, 0              ; нет чисел с плавающей точкой
    call    fscanf

    mov     rdi, [.prect]
    call    PerimeterRectangle
    movsd   [.prect+16], xmm0   ; &perimeter = &x1 + 4 * intSize

leave
ret

; // Ввод параметров треугольника из файла
; void InTriangle(void *t, FILE *ifst) {
;     fscanf(ifst, "%d%d%d%d", (int*)t,(int*)(t+intSize), (int*)(t+2*intSize),
;                (int*)(t+3*intSize));
;     fscanf(ifst, "%d%d%11s", (int*)(t+4*intSize), (int*)(t+5*intSize),
;                (char*)(t+6*intSize+doubleSize));
;     *((double*)(t+6*intSize)) = PerimeterTriangle(t);
; }
global InTriangle
InTriangle:
section .data
    .infmt1 db "%d%d%d%d",0
    .infmt2 db "%d%d%11s",0
section .bss
    .FILE   resq    1   ; временное хранение указателя на файл
    .trian  resq    1   ; адрес треугольника
section .text
push rbp
mov rbp, rsp

    ; Сохранение принятых аргументов
    mov     [.trian], rdi       ; сохраняется адрес треугольника
    mov     [.FILE], rsi        ; сохраняется указатель на файл

    ; Ввод треугольника из файла
    mov     rdi, [.FILE]
    mov     rsi, .infmt1        ; Формат входной строки
    mov     rdx, [.trian]       ; &x1
    mov     rcx, [.trian]
    add     rcx, 4              ; &y1 = &x1 + 4
    mov     r8, [.trian]
    add     r8, 8               ; &x2 = &x1 + 8
    mov     r9, [.trian]
    add     r9, 12              ; &y2 = &x1 + 12
    mov     rax, 0              ; нет чисел с плавающей точкой
    call    fscanf

    mov     rdi, [.FILE]
    mov     rsi, .infmt2        ; Формат входной строки
    mov     rdx, [.trian]
    add     rdx, 16             ; &x3 = &x1 + 16
    mov     rcx, [.trian]
    add     rcx, 20             ; &y3 = &x1 + 20
    mov     r8, [.trian]
    add     r8, 32              ; color = &x1 + 24 + 8
    mov     rax, 0              ; нет чисел с плавающей точкой
    call    fscanf

    mov     rdi, [.trian]
    call    PerimeterTriangle
    movsd   [.trian+24], xmm0   ; &perimeter = &x1 + 6 * intSize

leave
ret

;----------------------------------------------
; // Ввод параметров круга из файла
; void InCircle(void *c, FILE *ifst) {
;     fscanf(ifst, "%d%d%d%11s", (int*)c, (int*)(c+intSize),
;            (int*)(c+2*intSize), (char*)(c+3*intSize+doubleSize));
;     *((double*)(c+3*intSize)) = PerimeterCircle(c);
; }
global InCircle
InCircle:
section .data
    .infmt db "%d%d%d%11s",0
section .bss
    .FILE  resq    1   ; временное хранение указателя на файл
    .circ  resq    1   ; адрес круга
section .text
push rbp
mov rbp, rsp

    ; Сохранение принятых аргументов
    mov     [.circ], rdi        ; сохраняется адрес круга
    mov     [.FILE], rsi        ; сохраняется указатель на файл

    ; Ввод круга из файла
    mov     rdi, [.FILE]
    mov     rsi, .infmt         ; Формат - 1-й аргумент
    mov     rdx, [.circ]        ; &x
    mov     rcx, [.circ]
    add     rcx, 4              ; &y = &x + 4
    mov     r8,  [.circ]
    add     r8,  8              ; &r = &x + 8
    mov     r9,  [.circ]
    add     r9,  20             ; color = &x + 12 + 8
    mov     rax, 0              ; нет чисел с плавающей точкой
    call    fscanf

    mov     rdi, [.circ]
    call    PerimeterCircle
    movsd   [.circ+12], xmm0    ; &perimeter = &x + 3 * intSize

leave
ret

; // Ввод параметров обобщенной фигуры из файла
; int InShape(void *s, FILE *ifst) {
;     int k;
;     fscanf(ifst, "%d", &k);
;     switch(k) {
;         case 1:
;             *((int*)s) = RECTANGLE;
;             InRectangle(s+intSize, ifst);
;             return 1;
;         case 2:
;             *((int*)s) = TRIANGLE;
;             InTriangle(s+intSize, ifst);
;             return 1;
;        case 3:
;             *((int*)s) = CIRCLE;
;             InCircle(s+intSize, ifst);
;             return 1;
;         default:
;             return 0;
;     }
; }
global InShape
InShape:
section .data
    .tagFormat   db      "%d",0
section .bss
    .FILE       resq    1   ; временное хранение указателя на файл
    .pshape     resq    1   ; адрес фигуры
    .shapeTag   resd    1   ; признак фигуры
section .text
push rbp
mov rbp, rsp

    ; Сохранение принятых аргументов
    mov     [.pshape], rdi          ; сохраняется адрес фигуры
    mov     [.FILE], rsi            ; сохраняется указатель на файл

    ; чтение признака фигуры и его обработка
    mov     rdi, [.FILE]
    mov     rsi, .tagFormat
    mov     rdx, [.pshape]      ; адрес начала фигуры (ее признак)
    xor     rax, rax            ; нет чисел с плавающей точкой
    call    fscanf

    mov rcx, [.pshape]          ; загрузка адреса начала фигуры
    mov eax, [rcx]              ; и получение прочитанного признака
    cmp eax, [RECTANGLE]
    je .rectIn
    cmp eax, [TRIANGLE]
    je .trianIn
    cmp eax, [CIRCLE]
    je .circIn
    xor eax, eax    ; Некорректный признак - обнуление кода возврата
    jmp     .return
.rectIn:
    ; Ввод прямоугольника
    mov     rdi, [.pshape]
    add     rdi, 4
    mov     rsi, [.FILE]
    call    InRectangle
    mov     rax, 1  ; Код возврата - true
    jmp     .return
.trianIn:
    ; Ввод треугольника
    mov     rdi, [.pshape]
    add     rdi, 4
    mov     rsi, [.FILE]
    call    InTriangle
    mov     rax, 1  ; Код возврата - true
    jmp     .return
.circIn:
    ; Ввод круга
    mov     rdi, [.pshape]
    add     rdi, 4
    mov     rsi, [.FILE]
    call    InCircle
    mov     rax, 1  ; Код возврата - true
.return:

leave
ret

; // Ввод содержимого контейнера из указанного файла
; void InContainer(void *c, int *len, FILE *ifst) {
;     void *tmp = c;
;     while(!feof(ifst)) {
;         if(InShape(tmp, ifst)) {
;             tmp = tmp + shapeSize;
;             (*len)++;
;         }
;     }
; }
global InContainer
InContainer:
section .bss
    .pcont  resq    1   ; адрес контейнера
    .plen   resq    1   ; адрес для сохранения числа введенных элементов
    .FILE   resq    1   ; указатель на файл
section .text
    push rbp
    mov rbp, rsp

    mov [.pcont], rdi   ; сохраняется указатель на контейнер
    mov [.plen], rsi    ; сохраняется указатель на длину
    mov [.FILE], rdx    ; сохраняется указатель на файл

    xor rbx, rbx        ; число фигур = 0
    mov rdi, [.pcont]
    mov rsi, [.FILE]    ; перенос указателя на файл

.loop:
    ; сохранение рабочих регистров
    push rdi
    push rbx

    mov     rsi, [.FILE]
    mov     rax, 0      ; нет чисел с плавающей точкой
    call    InShape     ; ввод фигуры
    cmp rax, 0          ; проверка успешности ввода
    jle  .return        ; выход, если признак меньше или равен 0

    pop rbx
    inc rbx

    pop rdi
    add rdi, 48         ; адрес следующей фигуры

    jmp .loop
.return:
    mov rax, [.plen]    ; перенос указателя на длину
    mov [rax], ebx      ; занесение длины
leave
ret
