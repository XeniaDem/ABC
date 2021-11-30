;------------------------------------------------------------------------------
; perimeter.asm - единица компиляции, вбирающая функции вычисления периметра
;------------------------------------------------------------------------------

extern RECTANGLE
extern TRIANGLE
extern CIRCLE

;----------------------------------------------
; Вычисление периметра прямоугольника
; double PerimeterRectangle(void *r) {
;    *((double*)(r+4*intSize)) = 2.0 * (*((int*)(r+intSize) - *((int*)(r+3*intSize)) +
;           *((int*)(r+2*intSize)) - *((int*)r));
;    return *((double*)(r+4*intSize)):
;}
extern fprintf
global PerimeterRectangle
PerimeterRectangle:
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес прямоугольника
    mov eax, [rdi+4]      ; eax = y_up_left
    sub eax, [rdi+12]     ; eax = y_up_left - y_down_right
    add eax, [rdi+8]      ; eax = y_up_left - y_down_right + x_down_right
    sub eax, [rdi]        ; eax = половина от периметра всего прямоугольника
    shl eax, 1            ; eax = perimeter
    cvtsi2sd   xmm0, eax
    movsd [rdi+16], xmm0

leave
ret

;----------------------------------------------
; double PerimeterTriangle(void *t) {
;    double len1 = sqrt((*((int*)t)-*((int*)(t+2*intSize)) *
;           (*((int*)t)-*((int*)(t+2*intSize))) +
;           ((*((int*)(t+intSize))-*((int*)(t+3*intSize))) *
;           ((*((int*)(t+intSize))-*((int*)(t+3*intSize))));
;    double len2 = sqrt((*((int*)t)-*((int*)(t+4*intSize)) *
;           (*((int*)t)-*((int*)(t+4*intSize))) +
;           ((*((int*)(t+intSize))-*((int*)(t+5*intSize))) *
;           ((*((int*)(t+intSize))-*((int*)(t+5*intSize))));
;    double len1 = sqrt((*((int*)(t+2*intSize))-*((int*)(t+4*intSize)) *
;           (*((int*)(t+2*intSize))-*((int*)(t+4*intSize))) +
;           ((*((int*)(t+3*intSize))-*((int*)(t+5*intSize))) *
;           ((*((int*)(t+3*intSize))-*((int*)(t+5*intSize))));
;    *((double*)(r+6*intSize) = len1 + len2 + len3;
;    return *((double*)(r+6*intSize);
;}
global PerimeterTriangle
PerimeterTriangle:
section .data
    len1 dq 0.0
    len2 dq 0.0
    len3 dq 0.0
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес треугольника
    mov eax, [rdi]
    cvtsi2sd    xmm0, eax   ; xmm0 = x1
    mov eax, [rdi+8]
    cvtsi2sd    xmm1, eax   ; xmm1 = x2
    subsd       xmm0, xmm1  ; xmm0 = x1 - x2
    mulsd       xmm0, xmm0  ; xmm0 = (x1-x2)^2

    mov eax, [rdi+4]
    cvtsi2sd    xmm1, eax   ; xmm1 = y1
    mov eax, [rdi+12]
    cvtsi2sd    xmm2, eax   ; xmm2 = y2
    subsd       xmm1, xmm2  ; xmm1 = y1 - y2
    mulsd       xmm1, xmm1  ; xmm1 = (y1-y2)^2

    addsd       xmm0, xmm1  ; xmm0 = (x1-x2)^2 + (y1-y2)^2
    movsd       xmm1, xmm0
    sqrtsd      xmm0, xmm1  ; длина стороны (x1,y1), (x2,y2) треугольника
    movsd       [len1], xmm0

    ; В rdi адрес треугольника
    mov         eax, [rdi]
    cvtsi2sd    xmm0, eax   ; xmm0 = x1
    mov         eax, [rdi+16]
    cvtsi2sd    xmm1, eax   ; xmm1 = x3
    subsd       xmm0, xmm1  ; xmm0 = x1 - x3
    mulsd       xmm0, xmm0  ; xmm0 = (x1-x3)^2

    mov eax, [rdi+4]
    cvtsi2sd    xmm1, eax   ; xmm1 = y1
    mov         eax, [rdi+20]
    cvtsi2sd    xmm2, eax   ; xmm2 = y3
    subsd       xmm1, xmm2  ; xmm1 = y1 - y3
    mulsd       xmm1, xmm1  ; xmm1 = (y1-y3)^2
    addsd       xmm0, xmm1  ; xmm0 = (x1-x3)^2 + (y1-y3)^2
    movsd       xmm1, xmm0
    sqrtsd      xmm0, xmm1  ; длина стороны (x1,y1), (x3,y3) треугольника
    movsd       [len2], xmm0

    ; В rdi адрес треугольника
    mov eax, [rdi+8]
    cvtsi2sd    xmm0, eax  ; xmm0 = x2
    mov eax, [rdi+16]
    cvtsi2sd    xmm1, eax  ; xmm1 = x3
    subsd       xmm0, xmm1 ; xmm0 = x2 - x3
    mulsd       xmm0, xmm0 ; xmm0 = (x2-x3)^2

    mov eax, [rdi+12]
    cvtsi2sd    xmm1, eax  ; xmm1 = y2
    mov eax, [rdi+20]
    cvtsi2sd    xmm2, eax  ; xmm2 = y3
    subsd       xmm1, xmm2 ; xmm1 = y2 - y3
    mulsd       xmm1, xmm1 ; xmm1 = (y2-y3)^2

    addsd       xmm0, xmm1 ; xmm0 = (x2-x3)^2 + (y2-y3)^2
    movsd       xmm1, xmm0
    sqrtsd      xmm0, xmm1 ; длина стороны (x2,y2), (x3,y3) треугольника
    movsd       [len3], xmm0

    movsd       xmm0, [len1]
    addsd       xmm0, [len2]
    addsd       xmm0, [len3] ; xmm0 = len1 + len2 + len3
    movsd       [rdi+24], xmm0

leave
ret

;----------------------------------------------
; double PerimeterCircle(void *c) {
;    *((double*)(c+3*intSize) = (double)(2 * Pi *((int*)(c+2*intSize));
;    return *((double*)(c+3*intSize);
;}
global PerimeterCircle
PerimeterCircle:
section .data
    PiDouble   dq  3.14
section .text
push rbp
mov rbp, rsp
    ; В rdi адрес круга
    mov         eax, [rdi+8]
    cvtsi2sd    xmm0, eax        ; xmm0 = radius
    addsd       xmm0, xmm0       ; xmm0 = 2 * radius
    movsd       xmm1, [PiDouble]
    mulsd       xmm0, xmm1       ; xmm0 = 2 * Pi * radius
    movsd       [rdi+12], xmm0

leave
ret

;----------------------------------------------
; Вычисление периметра фигуры
;double PerimeterShape(void *s) {
;    int k = *((int*)s);
;    if(k == RECTANGLE) {
;        return PerimeterRectangle(s+intSize);
;    }
;    else if(k == TRIANGLE) {
;        return PerimeterTriangle(s+intSize);
;    }
;    else if(k == CIRCLE) {
;        return PerimeterCircle(s+intSize);
;    }
;    else {
;        return 0.0;
;    }
;}
global PerimeterShape
PerimeterShape:
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес фигуры
    mov eax, [rdi]
    cmp eax, [RECTANGLE]
    je rectPerimeter
    cmp eax, [TRIANGLE]
    je trianPerimeter
    cmp eax, [CIRCLE]
    je circPerimeter
    xor eax, eax
    cvtsi2sd    xmm0, eax
    jmp     return
rectPerimeter:
    ; Вычисление периметра прямоугольника
    add     rdi, 4
    call    PerimeterRectangle
    jmp     return
trianPerimeter:
    ; Вычисление периметра треугольника
    add     rdi, 4
    call    PerimeterTriangle
    jmp     return
circPerimeter:
    ; Вычисление периметра круга
    add     rdi, 4
    call    PerimeterCircle
return:
leave
ret

;----------------------------------------------
;// Вычисление суммы периметров всех фигур в контейнере
;double PerimeterSumContainer(void *c, int len) {
;    double sum = 0.0;
;    void *tmp = c;
;    for(int i = 0; i < len; i++) {
;        sum += PerimeterShape(tmp);
;        tmp = tmp + shapeSize;
;    }
;    return sum;
;}
global PerimeterSumContainer
PerimeterSumContainer:
section .data
    .sum    dq  0.0
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес начала контейнера
    mov ebx, esi            ; число фигур
    xor ecx, ecx            ; счетчик фигур
.loop:
    cmp ecx, ebx            ; проверка на окончание цикла
    jge .return             ; Перебрали все фигуры

    mov r10, rdi            ; сохранение начала фигуры
    call PerimeterShape     ; Получение периметра первой фигуры
    movsd xmm1, [.sum]      ; перенос накопителя суммы в регистр 1
    addsd xmm1, xmm0        ; накопление суммы
    movsd [.sum], xmm1
    inc rcx                 ; индекс следующей фигуры
    add r10, 48             ; адрес следующей фигуры
    mov rdi, r10            ; восстановление для передачи параметра
    jmp .loop
.return:
    movsd xmm0, xmm1
leave
ret
