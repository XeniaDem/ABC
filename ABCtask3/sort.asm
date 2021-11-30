;------------------------------------------------------------------------------
; sort.asm - единица компиляции, вбирающая функцию сортировки контейнера
;------------------------------------------------------------------------------

extern memcpy

extern PerimeterShape

;----------------------------------------------
; // меняет местами фигуры j и (j+1)
; void Swap(void *addr_j) {
;   char mem[48];
;   void *addr_j1 = addr_j + 48;
;   memcpy(mem, addr_j, 48);
;   memcpy(addr_j, addr_j1, 48);
;   memcpy(addr_j1, mem, 48);
;}
Swap:
section .bss
    .mem resb 48
section .text
push rbp
mov rbp, rsp
push rbx
    mov rbx, rdi

    mov rdi, .mem
    mov rsi, rbx
    mov rdx, 48
    call memcpy      ; в mem сохранен элемент j

    mov rdi, rbx
    lea rsi, [rdi+48]
    mov rdx, 48
    call memcpy     ; теперь элемент j равен элементу j+1

    lea rdi, [rbx+48]
    mov rsi, .mem
    mov rdx, 48
    call memcpy     ; полностью поменяли местами элементы j и j+1

pop rbx
leave
ret


;----------------------------------------------
; //Сортировка фигур по убыванию периметра
; void InsertionSort(void *arr, int n) {
;   void *i_addr = arr;
;   for (int i = 1; i < n; i++) {
;       void *j_addr = i_addr;
;       i_addr += 48;
;       double p1 = PerimeterShape(i_addr), p2;
;       int j = i - 1;
;       while (j >= 0) {
;           p2 = PerimeterShape(j_addr);
;           if (p1 > p2) {
;               Swap(j_addr);
;               j--;
;               j_addr -= 48;
;           } else {
;               break;
;           }
;       }
;   }
; }
global InsertionSort
InsertionSort:
section .bss
    .i_addr resq 1
    .j_addr resq 1
    .i      resd 1
    .n      resd 1
    .j      resd 1
    .p1     resq 1
    .p2     resq 1
section .text
push    rbp
mov     rbp, rsp

    mov [.i_addr], rdi    ; i_addr = arr
    mov [.n], esi         ; сохраняем переданное n
    mov ecx, 1
    mov [.i], ecx         ; i = 1

.for_start:
    mov ecx, [.i]
    cmp ecx, [.n]
    jge .func_end         ; i >= n выход из цикла for

    mov rdi, [.i_addr]
    mov [.j_addr], rdi    ; j_addr = i_addr
    add rdi, 48
    mov [.i_addr], rdi    ; i_addr += 48

    call PerimeterShape
    movsd [.p1], xmm0     ; p1 = PerimeterShape(i_addr)

    mov ecx, [.i]
    sub ecx, 1
    mov [.j], ecx         ; j = i -1

.while_start:
    mov ecx, [.j]
    cmp ecx, 0
    jl .for_end           ; j < 0 выход из цикла while

    mov rdi, [.j_addr]
    call PerimeterShape
    movsd [.p2], xmm0     ; p2 = PerimeterShape(j_addr)

    movsd xmm0, qword[.p1]
    movsd xmm1, qword[.p2]
    comisd xmm0, xmm1     ; сравнить p1 и p2
    jbe .for_end          ; p1 <= p2 выход из цикла while

    mov rdi, [.j_addr]
    call Swap             ; Swap(j_addr)

    mov ecx, [.j]
    sub ecx, 1
    mov [.j], ecx         ; j--

    mov rdi, [.j_addr]
    sub rdi, 48
    mov [.j_addr], rdi    ; j_addr -= 48

    jmp .while_start

.for_end:
    mov ecx, [.i]
    add ecx, 1
    mov [.i], ecx         ; i++
    jmp .for_start


.func_end:
leave
ret
