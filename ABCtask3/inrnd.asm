; file.asm - использование файлов в NASM
extern printf
extern rand
extern memcpy

extern PerimeterRectangle
extern PerimeterTriangle
extern PerimeterCircle

extern RECTANGLE
extern TRIANGLE
extern CIRCLE


;----------------------------------------------
; // rnd.c - содержит генератор случайных чисел в диапазоне от 1 до 200
; int Random() {
;     return rand() % 200 + 1;
; }
global Random
Random:
section .data
    .i200     dq      200
section .text
push rbp
mov rbp, rsp

    xor     rax, rax    ;
    call    rand        ; запуск генератора случайных чисел
    xor     rdx, rdx    ; обнуление перед делением
    idiv    qword[.i200]       ; (/%) -> остаток в rdx
    mov     rax, rdx
    inc     rax         ; должно сформироваться случайное число

leave
ret

;----------------------------------------------
; Заполняет значение поля цвет у структуры
; На вход принимает адрес, куда писать цвет
; void RandomColor(void *addr) {
;     char colors[][12] = {"RED", "ORANGE", "YELLOW", "GREEN",
;               "LIGHT_BLUE", "BLUE", "VIOLET"};
;     int i = Random() % 7; 7 - количество цветов
;     memcpy(addr, colors[i], 12);
; }
global RandomColor
RandomColor:
section .data
    .total_colors dq 7
    .color_size   dq 12
    ;На каждый цвет отводится по 12 байт
    .colors db "RED",0,0,0,0,0,0,0,0,0
            db "ORANGE",0,0,0,0,0,0
            db "YELLOW",0,0,0,0,0,0
            db "GREEN",0,0,0,0,0,0,0
            db "LIGHT_BLUE",0,0
            db "BLUE",0,0,0,0,0,0,0,0
            db "VIOLET",0,0,0,0,0,0
section .bss
    .addr resq 1
section .text
push rbp
mov rbp, rsp

    mov [.addr], rdi          ;сохраняем адрес, куда надо записать цвет
    call Random
    xor rdx, rdx
    idiv qword[.total_colors] ; (/%) -> остаток в rdx
    mov rax, rdx              ; rax = Random() % total_colors
    imul rax, 12              ; rax = смещение внутри массива цветов

    mov rsi, rax
    add rsi, .colors          ; rsi = адрес нужного цвета
    mov rdi, [.addr]          ; где будет храниться цвет
    mov rdx, [.color_size]    ; сколько байт копировать
    call memcpy

leave
ret


;----------------------------------------------
;// Случайный ввод параметров прямоугольника
;void InRndRectangle(void *r) {
;   int x1, x2, y1, y2;
;   do {
;       x1 = Random();
;       x2 = Random();
;       y1 = Random();
;       y2 = Random();
;   } while (x2 <= x1 || y1 <= y2);
;   *((int*)r) = x1;
;   *((int*)(r+intSize)) = y1;
;   *((int*)(r+2*intSize)) = x2;
;   *((int*)(r+3*intSize)) = y2;
;   RandomColor(r+4*intSize+doubleSize);
;   *((double*)(r+4*intSize)) = PerimeterRectangle(r);
;}
global InRndRectangle
InRndRectangle:
section .bss
    .prect  resq 1   ; адрес прямоугольника
    .x1 resd 1
    .x2 resd 1
    .y1 resd 1
    .y2 resd 1
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес прямоугольника
    mov     [.prect], rdi

    ; Генерация сторон прямоугольника
    .start_loop:
    call    Random
    mov     [.x1], eax
    call    Random
    mov     [.x2], eax
    call    Random
    mov     [.y1], eax
    call    Random
    mov     [.y2], eax

    mov eax, [.x2]
    cmp eax, [.x1]
    jle .start_loop        ; x_down_right <= x_up_left
    mov eax, [.y1]
    cmp eax, [.y2]         ; y_up_left <= y_down_right
    jle .start_loop

    ; цикл закончился
    ; заполняем параметры фигуры
    mov rdi, [.prect]
    mov eax, [.x1]
    mov [rdi], eax
    mov eax, [.y1]
    mov [rdi+4], eax
    mov eax, [.x2]
    mov [rdi+8], eax
    mov eax, [.y2]
    mov [rdi+12], eax

    add rdi, 24      ; адрес хранения цвета = r+4*intSize+doubleSize
    call RandomColor

    mov rdi, [.prect]
    call PerimeterRectangle
    movsd [.prect+16], xmm0    ;&perimeter = r+4*intSize

leave
ret

;----------------------------------------------
;// Случайный ввод параметров треугольника
;void InRndTriangle(void *t) {
    ;int x1, y1, x2, y2, x3, y3, det;
    ;do {
       ;x1 = Random();
       ;x2 = Random();
       ;x3 = Random();
       ;y1 = Random();
       ;y2 = Random();
       ;y3 = Random();
       ;// Треугольник существует, если векторы, его образующие, неколлинеарны
       ;// т. е. определитель следующей матрицы отличен от нуля
       ;// [(x2-x1 , x3-x1)
       ;//  (y2-y1 , y3-y1)]
       ;det = (x2-x1)*(y3-y1)-(x3-x1)*(y2-y1);
    ;} while (det == 0);
    ;*((int*)t) = x1;
    ;*((int*)(t+intSize)) = y1;
    ;*((int*)(t+2*intSize)) = x2;
    ;*((int*)(t+3*intSize)) = y2;
    ;*((int*)(t+4*intSize)) = x3;
    ;*((int*)(t+5*intSize)) = y3;
    ;RandomColor(t+6*intSize+doubleSize);
    ;*((double*)(t+6*intSize) = PerimeterRectangle(t);
;}
global InRndTriangle
InRndTriangle:
section .bss
    .ptrian  resq 1   ; адрес треугольника
    .x1 resd 1
    .x2 resd 1
    .x3 resd 1
    .y1 resd 1
    .y2 resd 1
    .y3 resd 1
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес треугольника
    mov     [.ptrian], rdi

    ; Генерация координат вершин треугольника
    .start_loop:
    call    Random
    mov     [.x1], eax
    call    Random
    mov     [.x2], eax
    call    Random
    mov     [.x3], eax
    call    Random
    mov     [.y1], eax
    call    Random
    mov     [.y2], eax
    call    Random
    mov     [.y3], eax

    ; Вычисление определителя
    xor     rax, rax
    mov     eax, [.x2]
    sub     eax, [.x1] ; eax = x2 - x1
    mov     edx, [.y3]
    sub     edx, [.y1] ; edx = y3 - y1
    imul    eax, edx   ; eax = (x2-x1) * (y3-y1)

    mov     ecx, [.x3]
    sub     ecx, [.x1] ; ecx = x3 - x1
    mov     edx, [.y2]
    sub     edx, [.y1] ; edx = y2 - y1
    imul    ecx, edx   ; ecx = (x3-x1) * (y2-y1)

    sub     eax, ecx   ;det
    cmp     eax, 0
    je      .start_loop ;det == 0

    ; цикл закончился
    ; заполняем параметры фигуры
    mov rdi, [.ptrian]
    mov eax, [.x1]
    mov [rdi], eax
    mov eax, [.y1]
    mov [rdi+4], eax
    mov eax, [.x2]
    mov [rdi+8], eax
    mov eax, [.y2]
    mov [rdi+12], eax
    mov eax, [.x3]
    mov [rdi+16], eax
    mov eax, [.y3]
    mov [rdi+20], eax

    add rdi, 32           ; адрес хранения цвета  = t+6*intSize+doubleSize
    call RandomColor

    mov rdi, [.ptrian]
    call PerimeterTriangle
    movsd [.ptrian+24], xmm0   ; &perimeter = t+6*intSize

leave
ret

;----------------------------------------------
;// Случайный ввод параметров круга
;void InRndCircle(void *c) {
;   *((int*)c) = Random();
;   *((int*)(c+intSize)) = Random();
;   *((int*)(c+2*intSize)) = Random();
;   RandomColor(c+3*intSize+doubleSize);
;   *((double*)(c+3*intSize) = PerimeterCircle(c);
;}
global InRndCircle
InRndCircle:
section .bss
    .pcirc  resq 1   ; адрес круга
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес круга
    mov     [.pcirc], rdi
    ; Генерация параметров круга
    ; сразу же заполняем параметры фигуры
    call    Random
    mov     rdi, [.pcirc]
    mov     [rdi], eax
    call    Random
    mov     rdi, [.pcirc]
    mov     [rdi+4], eax
    call    Random
    mov     rdi, [.pcirc]
    mov     [rdi+8], eax

    add     rdi, 20        ; адрес хранения цвета  = c+3*intSize+doubleSize
    call    RandomColor

    mov     rdi, [.pcirc]
    call    PerimeterCircle
    movsd   [.pcirc+12], xmm0   ; &perimeter = c+3*intSize

leave
ret

;----------------------------------------------
;// Случайный ввод обобщенной фигуры
;int InRndShape(void *s) {
    ;int k = rand() % 3 + 1;
    ;switch(k) {
        ;case 1:
            ;*((int*)s) = RECTANGLE;
            ;InRndRectangle(s+intSize);
            ;return 1;
        ;case 2:
            ;*((int*)s) = TRIANGLE;
            ;InRndTriangle(s+intSize);
            ;return 1;
        ;case 3:
            ;*((int*)s) = CIRCLE;
            ;InRndCircle(s+intSize);
            ;return 1;
        ;default:
            ;return 0;
    ;}
;}
global InRndShape
InRndShape:
section .data
    .i3         dq 3
section .bss
    .pshape     resq    1   ; адрес фигуры
    .key        resd    1   ; ключ
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес фигуры
    mov [.pshape], rdi

    ; Формирование признака фигуры
    xor     rax, rax    ;
    call    rand        ; запуск генератора случайных чисел
    xor     rdx, rdx
    idiv    qword[.i3]  ; (/%) -> остаток в rdx
    mov     eax, edx
    inc     eax         ; формирование признака фигуры (1 или 2 или 3)


    mov     rdi, [.pshape]
    mov     [rdi], eax      ; запись ключа в фигуру
    cmp eax, [RECTANGLE]
    je .rectInrnd
    cmp eax, [TRIANGLE]
    je .trianInRnd
    cmp eax, [CIRCLE]
    je .circInRnd
    xor eax, eax        ; код возврата = 0
    jmp     .return
.rectInrnd:
    ; Генерация прямоугольника
    add     rdi, 4
    call    InRndRectangle
    mov     eax, 1      ; код возврата = 1
    jmp     .return
.trianInRnd:
    ; Генерация треугольника
    add     rdi, 4
    call    InRndTriangle
    mov     eax, 1      ; код возврата = 1
    jmp     .return
.circInRnd:
    ; Генерация круга
    add     rdi, 4
    call    InRndCircle
    mov     eax, 1      ; код возврата = 1
.return:
leave
ret

;----------------------------------------------
;// Случайный ввод содержимого контейнера
;void InRndContainer(void *c, int *len, int size) {
    ;void *tmp = c;
    ;while(*len < size) {
        ;if(InRndShape(tmp)) {
            ;tmp = tmp + shapeSize;
            ;(*len)++;
        ;}
    ;}
;}
global InRndContainer
InRndContainer:
section .bss
    .pcont  resq    1   ; адрес контейнера
    .plen   resq    1   ; адрес для сохранения числа введенных элементов
    .psize  resd    1   ; число порождаемых элементов
section .text
push rbp
mov rbp, rsp

    mov [.pcont], rdi   ; сохраняется указатель на контейнер
    mov [.plen], rsi    ; сохраняется указатель на длину
    mov [.psize], edx   ; сохраняется число порождаемых элементов
    ; В rdi адрес начала контейнера
    xor ebx, ebx        ; число фигур = 0
.loop:
    cmp ebx, edx
    jge     .return
    ; сохранение рабочих регистров
    push rdi
    push rbx
    push rdx

    call    InRndShape  ; ввод фигуры
    cmp rax, 0          ; проверка успешности ввода
    jle  .return        ; выход, если признак меньше или равен 0

    pop rdx
    pop rbx
    inc rbx

    pop rdi
    add rdi, 48             ; адрес следующей фигуры

    jmp .loop
.return:
    mov rax, [.plen]    ; перенос указателя на длину
    mov [rax], ebx      ; занесение длины
leave
ret
