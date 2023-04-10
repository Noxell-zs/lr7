.global _start

_start:
  mov X0, #1                 // 1 = StdOut - поток вывода
  ldr X1, =hello             // строка для вывода на экран
  mov X2, #19                // длина строки
  mov X8, #64                // функция write
  svc 0                      // вызов функции Linux
  
  mov X9, 0
  mov X10, 0                 // флаг пробела
  mov X11, 0                 // индекс последнего слова
  read_str: 
    mov X0, #0               // 0 = StdIn - поток ввода
    ldr X1, =buffer          // строка для вывода на экран
    mov X2, #1               // длина строки
    mov X8, #63              // функция read
    svc 0                    // вызов функции Linux
    
    add X9, X9, #1

    ldr X0, =buffer
    ldr X0, [X0]
    
    str X0, [sp, #-16]!
    
    cmp X0, 10
    b.eq read_str_end
    
    cmp X0, 32               //space
    b.eq is_space
    b.ne is_not_space
    is_space:
      mov X10, #1
      b is_space_end
    is_not_space:
      cmp X10, #0
      b.eq prev_not_space
        mov X11, X9
      prev_not_space:
      mov X10, #0
      b is_space_end
    is_space_end:
    
    b read_str
  read_str_end:
    
  mov X4, #16
  mul X5, X9, X4
  add sp, sp, X5
  
  
  mov X5, #10
  ldr X4, =buffer
  str X5, [X4]
  mov X0, #1
  ldr X1, =buffer
  mov X2, #1
  mov X8, #64
  svc 0
  

  mov X10, 0
  print_str2:
    ldr X5, [sp], #-16
    ldr X4, =buffer
    str X5, [X4]
    
    mov X0, #1
    ldr X1, =buffer
    mov X2, #1
    mov X8, #64
    svc 0
    
    add X10, X10, #1
    cmp X10, X11
    b.lt print_str2


  mov X5, #10
  ldr X4, =buffer
  str X5, [X4]
  mov X0, #1
  ldr X1, =buffer
  mov X2, #1
  mov X8, #64
  svc 0
  
  mov X4, #16
  mul X5, X11, X4
  add sp, sp, X5


  mov X10, 0
  print_str3:
    ldr X5, [sp], #-16
    ldr X4, =buffer
    
    cmp X5, #'a'
    b.lt not_mutate
    cmp X5, #'z'
    b.gt not_mutate
      sub X5, X5, #('a'-'A')
    not_mutate:
    
    str X5, [X4]
    
    mov X0, #1
    ldr X1, =buffer
    mov X2, #1
    mov X8, #64
    svc 0
    
    add X10, X10, #1
    cmp X10, X9
    b.lt print_str3
    
    
  mov X5, #10
  ldr X4, =buffer
  str X5, [X4]
  mov X0, #1
  ldr X1, =buffer
  mov X2, #1
  mov X8, #64
  svc 0
  

  mov X0, #0                 // 0 как код возврата
  mov X8, #93                // 93 - завершение программы
  svc 0
 
.data
  hello: .ascii "Enter the string:\n"
  buffer: .space 4
