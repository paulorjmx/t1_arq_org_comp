# Autor: Paulo Ricardo Jordao Miranda
# Trabalho entregue como requisito à disciplina de Arquitetura e Organização de Computadores


.data
    e_fp:  .float 0.000001 # Error constant used in square root function
    one_fp:    .float 1.0  # One constant used in square root function
    two_fp:    .float 2.0  # Two
    zero_fp:    .float 0.0 # Zero float point constant used in square root and imc function
    str_title:  .asciiz "Bem-vindo a Calculadora Assembly\n"
    str_choose: .asciiz "\nEscolha uma das opcoes abaixo\n\n"
    str_op1:    .asciiz "[1] Soma\n"
    str_op2:    .asciiz "[2] Subtracao\n"
    str_op3:    .asciiz "[3] Multiplicacao\n"
    str_op4:    .asciiz "[4] Divisao\n"
    str_op5:    .asciiz "[5] Potencia\n"
    str_op6:    .asciiz "[6] IMC (Indice de Massa Corporal)\n"
    str_op7:    .asciiz "[7] Sequencia de Fibonacci\n"
    str_op8:    .asciiz "[8] Raiz Quadrada\n"
    str_op9:    .asciiz "[9] Tabuada de um numero\n"
    str_op10:   .asciiz "[10] Fatorial\n"
    str_op11:   .asciiz "[11] Sair\n\n"
    str_usr_in: .asciiz "-> "
    str_op_in:  .asciiz "\nEntre com o numero: "
    str_op1_in: .asciiz "Entre com o primeiro operando: "
    str_op2_in: .asciiz "\nEntre com o segundo operando: "
    str_weight_in:    .asciiz "Entre com o peso (Ex: 54.12): "
    str_height_in:    .asciiz "\nEntre com a altura (Ex: 1.78): "
    str_error_choice:   .asciiz "\nErro: Escolha uma opcao valida!\n"
    str_error_zero_div: .asciiz "\nErro: O divisor tem de ser diferente de zero.\n"
    str_error_negative_exp: .asciiz "\nErro: O expoente nao pode ser negativo.\n"
    str_error_overflow: .asciiz "\nErro: Digite um numero entre -32768 e 32767.\n"
    str_error_height_neg_zero:  .asciiz "\nErro: A altura nao pode ser negativa ou igual a zero.\n"
    str_error_weight:   .asciiz "\nErro: O peso nao pode ser negativo.\n"
    str_error_negative:   .asciiz "\nErro: Digite um numero positivo.\n"
    str_error_interval:   .asciiz "\nErro: O primeiro numero e maior que o segundo.\n"
    str_continue:   .asciiz "\n(Aperte Enter para continuar)\n"
    str_res: .asciiz "\nResultado: "
    str_res_fibonacci:  .asciiz "\nSequencia de Fibonacci no intervalo: "
    str_tabuada_res:    .asciiz "\nA tabuada de "
    str_times:  .asciiz " x "
    str_equal:  .asciiz " = "
    str_imc_res:    .asciiz "\nO seu IMC e: "
    str_space:  .asciiz " "
    str_new_line:   .asciiz "\n"
    str_enter:  .byte

.text

.globl main

    main:
        la $a0, str_title
        li $v0, 4
        syscall

        # Prints the program's menu and get the user's choice
        # print_menu get the user's choice and return in $v0
    user_choose: jal print_menu

        # Puts the user choice in $t0
        move $t0, $v0
        blt $t0, $zero, error_choice  # if($t0 < 0) If the user choice is negative or invalid
        li $t1, 7
        bgt $t0, $t1, others_ops    # if($t0 > 7) If the user choice is greater than 7
        li $t1, 6
        beq $t0, $t1, imc   # Jump to imc function

        # Print: "Entre com o primeiro operando"
        la $a0, str_op1_in
        li $v0, 4
        syscall

        # Gets the first operand
        li $v0, 5
        syscall
        move $t2, $v0

        # Print: "Entre com o segundo operando"
        la $a0, str_op2_in
        li $v0, 4
        syscall

        # Gets the second operand
        li $v0, 5
        syscall
        move $t3, $v0

        li $t1, 1
        beq $t0, $t1, soma
        li $t1, 2
        beq $t0, $t1, subtra
        li $t1, 3
        beq $t0, $t1, multip
        li $t1, 4
        beq $t0, $t1, divisao
        li $t1, 5
        beq $t0, $t1, potencia
        li $t1, 7
        beq $t0, $t1, fibonacci

    soma:
        move $a0, $t2   # Put the first argument in $a0
        move $a1, $t3   # Put the second argument in $a1
        jal soma_func


        move $a0, $v0   # Get the result and put in $a0 that is arg of print_result
        jal print_result    # Call function to print result (void print_result(int result))

        j user_choose

    subtra:
        move $a0, $t2   # Put the first arg in $a0
        move $a1, $t3   # Put the second arg in $a1
        jal sub_func

        move $a0, $v0   # Get the result and put in $a0 that is arg of print_result
        jal print_result

        j user_choose

    multip:
        move $a0, $t2
        move $a1, $t3
        jal mult_func

        addi $t7, $zero, 32767
        beq $v0, $t7, user_choose   # If an error occurs

        move $a0, $v0
        jal print_result

        j user_choose

    divisao:
        move $a0, $t2
        move $a1, $t3
        jal divisao_func

        addi $t7, $zero, 32768
        beq $v0, $t7, user_choose   # If an error occurs

        move $a0, $v0
        jal print_result

        j user_choose

    potencia:
        move $a0, $t2
        move $a1, $t3
        jal potencia_func

        li $t7, -1
        beq $v0, $t7, user_choose   # If an error occurs

        move $a0, $v0
        jal print_result

        j user_choose

    imc:
        # Print: "Entre com seu peso: "
        la $a0, str_weight_in
        li $v0, 4
        syscall

        # Get the user's weight (float point) input
        li $v0, 6
        syscall
        mov.s $f2, $f0

        # Print "Entre com sua altura: "
        la $a0, str_height_in
        li $v0, 4
        syscall

        # Get the user's height (float point) input
        li $v0, 6
        syscall
        mov.s $f3, $f0

        jal imc_func    # Compute the IMC and put the result in the $f0

        mov.s $f12, $f0 # Move the result of function to $f12

        l.s $f8, zero_fp
        c.eq.s $f0, $f8 # Verify if function returns error
        bc1t user_choose

        # Prints: "Seu IMC e: "
        la $a0, str_imc_res
        li $v0, 4
        syscall

        # Prints the result of IMC
        li $v0, 2
        syscall

        la $a0, str_continue
        li $v0, 4
        syscall

        la $a0, str_enter
        li $a1, 1
        li $v0, 8
        syscall

        j user_choose

    fibonacci:
        move $a0, $t2
        move $a1, $t3
        jal fibonacci_func

        j user_choose



    # Below is the operation that uses one parameter only
    others_ops:
        li $t1, 11
        bge $t0, $t1, exit  # if($t0 > 11) exits. If the user choice is greater or equal 11
        li $t1, 8
        bge $t0, $t1, square_root

        # Print: "Entre com o numero: "
        la $a0, str_op_in
        li $v0, 4
        syscall

        # Get the number type by user
        li $v0, 5
        syscall

        li $t1, 9
        bge $t0, $t1, tabuada
        li $t1, 10
        bge $t0, $t1, factorial

        square_root:
            la $a0, str_op_in
            li $v0, 4
            syscall

            li $v0, 6
            syscall

            mov.s $f2, $f0
            jal square_root_func

            c.lt.s $f0, $f10 # If the return value is negative
            bc1t user_choose

            # Prints the result
            la $a0, str_res
            li $v0, 4
            syscall

            mov.s $f12, $f0
            li $v0, 2
            syscall

            la $a0, str_continue
            li $v0, 4
            syscall

            la $a0, str_enter
            li $a1, 1
            li $v0, 8
            syscall

            j user_choose


        tabuada:
            move $a0, $v0
            jal tabuada_func

            j user_choose


        factorial:
            move $a0, $v0
            jal factorial_func

            blt $v0, $zero, user_choose # If an error occurs

            move $a0, $v0
            jal print_result

            j user_choose


    # Prints the error related to the user's choice on screen and go to menu
    error_choice:
        la $a0, str_error_choice
        li $v0, 4
        syscall

        la $a0, str_continue
        syscall

        la $a0, str_enter
        li $a1, 1
        li $v0, 8
        syscall

        j user_choose


    # Exits the program
    exit:
        li $v0, 10
        syscall


# The functions used in the program is below this section

    # Print the menu, and return the user choice in $v0
    print_menu:
        addi $sp, $sp, -8
        sw $ra, 4($sp)
        sw $fp, 0($sp)
        move $fp, $sp

        la $a0, str_choose
        li $v0, 4
        syscall

        la $a0, str_op1
        syscall

        la $a0, str_op2
        syscall

        la $a0, str_op3
        syscall

        la $a0, str_op4
        syscall

        la $a0, str_op5
        syscall

        la $a0, str_op6
        syscall

        la $a0, str_op7
        syscall

        la $a0, str_op8
        syscall

        la $a0, str_op9
        syscall

        la $a0, str_op10
        syscall

        la $a0, str_op11
        syscall

        la $a0, str_usr_in
        syscall

        # Reads the user choice
        li $v0, 5
        syscall

        lw $ra, 4($sp)
        lw $fp, 0($sp)
        addi $sp, $sp, 8
        jr $ra

    # Print integer result
    print_result:
        addi $sp, $sp, -12
        sw $a0, 8($sp)
        sw $ra, 4($sp)
        sw $fp, 0($sp)
        move $fp, $sp

        la $a0, str_res # Prints "Resultado:"
        li $v0, 4
        syscall

        lw $a0, 8($fp)  # Prints the result
        li $v0, 1
        syscall

        la $a0, str_continue    # Prints "Aperte enter para continua"
        li $v0, 4
        syscall

        la $a0, str_enter   # Reads the enter
        li $a1, 1
        li $v0, 8
        syscall

        lw $a0, 8($sp)
        lw $ra, 4($sp)
        lw $fp, 0($sp)
        addi $sp, $sp, 12

        jr $ra


    # Sum of two numbers
    soma_func:
        addi $sp, $sp, -16
        sw $a1, 12($sp)
        sw $a0, 8($sp)
        sw $ra, 4($sp)
        sw $fp, 0($sp)
        move $fp, $sp

        add $v0, $a0, $a1

        lw $a1, 12($sp)
        lw $a0, 8($sp)
        lw $ra, 4($sp)
        lw $fp, 0($sp)
        addi $sp, $sp, 16

        jr $ra

    # Subtraction of two numbers
    sub_func:
        addi $sp, $sp, -16
        sw $a1, 12($sp)
        sw $a0, 8($sp)
        sw $ra, 4($sp)
        sw $fp, 0($sp)
        move $fp, $sp

        sub $v0, $a0, $a1

        lw $a1, 12($sp)
        lw $a0, 8($sp)
        lw $ra, 4($sp)
        lw $fp, 0($sp)
        addi $sp, $sp, 16

        jr $ra

    # Multiplication of two numbers
    mult_func:
        addi $sp, $sp, -16
        sw $a1, 12($sp)
        sw $a0, 8($sp)
        sw $ra, 4($sp)
        sw $fp, 0($sp)
        move $fp, $sp

        addi $t7, $zero, -32768
        addi $t8, $zero, 32767
        blt $a0, $t7, error_overflow_mult
        blt $a1, $t7, error_overflow_mult
        bgt $a0, $t8, error_overflow_mult
        bgt $a1, $t8, error_overflow_mult

        mul $v0, $a0, $a1
        j return_mult

        # Error: Input overflow
        error_overflow_mult:
            la $a0, str_error_overflow
            li $v0, 4
            syscall

            la $a0, str_continue
            syscall

            la $a0, str_enter
            li $a1, 1
            li $v0, 8
            syscall

            addi $v0, $zero, 32767  # Error return

    return_mult:
        lw $a1, 12($sp)
        lw $a0, 8($sp)
        lw $ra, 4($sp)
        lw $fp, 0($sp)
        addi $sp, $sp, 16

        jr $ra

    # Division of two numbers
    divisao_func:
        addi $sp, $sp, -16
        sw $a1, 12($sp)
        sw $a0, 8($sp)
        sw $ra 4($sp)
        sw $fp, 0($sp)
        move $fp, $sp

        beq $a1, $zero, zero_div    # if the divisor is zero

        addi $t7, $zero, -32768
        addi $t8, $zero, 32767
        blt $a0, $t7, error_overflow_div
        blt $a1, $t7, error_overflow_div
        bgt $a0, $t8, error_overflow_div
        bgt $a1, $t8, error_overflow_div

        div $v0, $a0, $a1
        j return_div

        # Error: Division by zero
        zero_div:
            la $a0, str_error_zero_div
            li $v0, 4
            syscall

            la $a0, str_continue
            syscall

            la $a0, str_enter
            li $a1, 1
            li $v0, 8
            syscall

            addi $v0, $zero, 32768  # Error on operation
            j return_div

        # Error: input overflow
        error_overflow_div:
            la $a0, str_error_overflow
            li $v0, 4
            syscall

            la $a0, str_continue
            syscall

            la $a0, str_enter
            li $a1, 1
            li $v0, 8
            syscall

            addi $v0, $zero, 32768  # Error on operation

    return_div:
        lw $a1, 12($sp)
        lw $a0, 8($sp)
        lw $ra, 4($sp)
        lw $fp, 0($sp)
        addi $sp, $sp, 16

        jr $ra

    # Power function
    potencia_func:
        addi $sp, $sp, -16
        sw $a1, 12($sp)
        sw $a0, 8($sp)
        sw $ra, 4($sp)
        sw $fp, 0($sp)
        move $fp, $sp

        blt $a1, $zero, error_negative_exp  # if the expoent is negative

        li $t8, 1
        li $v0, 1
        p_loop: blt $a1, $t8, sai_p_loop
                mul $v0, $v0, $a0
                addi $a1, $a1, -1
                j p_loop

        error_negative_exp:
            la $a0, str_error_negative_exp
            li $v0, 4
            syscall

            la $a0, str_continue
            syscall

            la $a0, str_enter
            li $a1, 1
            li $v0,8
            syscall

            li $v0, -1  # return error (-1)

        sai_p_loop:
            lw $a1, 12($sp)
            lw $a0, 8($sp)
            lw $ra, 4($sp)
            lw $fp, 0($sp)
            addi $sp, $sp, 16

            jr $ra

    # IMC function
    imc_func:
        addi $sp, $sp, -16
        s.s $f3, 12($sp)
        s.s $f2, 8($sp)
        sw $ra, 4($sp)
        sw $fp, 0($sp)
        move $fp, $sp

        l.s $f8, zero_fp    # Load the constant 0.0 into $f8
        c.le.s $f3, $f8   # if height is negative or equal to zero
        bc1t height_negative_zero   # Branches if the floating point condition above is true
        c.lt.s $f2, $f8    # if weight is negative
        bc1t weight_negative    # Branches if the floating point condition above is true



        mul.s $f3, $f3, $f3 # height * height
        div.s $f0, $f2, $f3 # weight / (height * height)
        j return_imc

        # Error: height is negative or equal to zero
        height_negative_zero:
            la $a0, str_error_height_neg_zero
            li $v0, 4
            syscall

            # Wait for the user press enter to see the result
            la $a0, str_continue
            li $v0, 4
            syscall

            la $a0, str_enter
            li $a1, 1
            li $v0, 8
            syscall

            mov.s $f0, $f8  # Return error
            j return_imc

        # Error: Weight is negative
        weight_negative:
            la $a0, str_error_weight
            li $v0, 4
            syscall

            # Wait for the user press enter to see the result
            la $a0, str_continue
            li $v0, 4
            syscall

            la $a0, str_enter
            li $a1, 1
            li $v0, 8
            syscall

            mov.s $f0, $f8  # Return error

    return_imc:
        l.s $f3, 12($sp)
        l.s $f2, 8($sp)
        lw $ra, 4($sp)
        lw $fp, 0($sp)
        addi $sp, $sp, 16

        jr $ra

    # Fibonacci function
    fibonacci_func:
        addi $sp $sp, -16
        sw $a1, 12($sp)
        sw $a0, 8($sp)
        sw $ra, 4($sp)
        sw $fp, 0($sp)
        move $fp, $sp

        ble $a0, $zero, error_negative_fib
        ble $a1, $zero, error_negative_fib
        bgt $a0, $a1, error_interval_negative

        # Get the term of the sequence that correspond the first number in interval
        li $t7, 1
        li $t8, 0   # F1 = 1, the first term of fibonacci
        li $t9, 1   # F2 = 1, the second term of fibonacci

        first_term_loop: bge $t7, $a0, end_first_term_loop
                         move $t6, $t9  # $t6 is like an auxiliar
                         add $t9, $t9, $t8  # $t9 = Fn-1 + Fn-2
                         move $t8, $t6
                         addi $t7, $t7, 1
                         j first_term_loop


        end_first_term_loop:
            la $a0, str_res_fibonacci
            li $v0, 4
            syscall

            move $a0, $t9
            li $v0, 1
            syscall

        # Continue to compute the sequence
        second_term_loop: bge $t7, $a1, return_fib
                          move $t6, $t9  # $t6 is like an auxiliar
                          add $t9, $t9, $t8  # $t9 = Fn-1 + Fn-2
                          move $t8, $t6
                          addi $t7, $t7, 1

                          # Print the parcial result
                          la $a0, str_space
                          li $v0, 4
                          syscall

                          move $a0, $t9
                          li $v0, 1
                          syscall

                          j second_term_loop


        error_interval_negative:
            la $a0, str_error_interval
            li $v0, 4
            syscall

            j return_fib

        error_negative_fib:
            la $a0, str_error_negative
            li $v0, 4
            syscall


        return_fib:
            # Wait for the user press enter to see the result
            la $a0, str_continue
            li $v0, 4
            syscall

            la $a0, str_enter
            li $a1, 1
            li $v0, 8
            syscall

            sw $a1, 12($sp)
            sw $a0, 8($sp)
            sw $ra, 4($sp)
            sw $fp, 0($sp)
            addi $sp, $sp, 16

            jr $ra

    # Factorial function
    factorial_func:
        addi $sp, $sp, -12
        sw $a0, 8($sp)
        sw $ra, 4($sp)
        sw $fp, 0($sp)
        move $fp, $sp

        blt $a0, $zero, error_negative_factorial
        li $v0, 1

        # Loop to calculate the factorial
        factorial_loop: ble $a0, $zero, return_factorial
                        mul $v0, $v0, $a0
                        addi $a0, $a0, -1
                        j factorial_loop

        # Print the error of negative argument
        error_negative_factorial:
                la $a0, str_error_negative
                li $v0, 4
                syscall

                la $a0, str_continue
                syscall

                la $a0, str_enter
                li $a1, 1
                li $v0, 8
                syscall

                li $v0, -1

        return_factorial:
            lw $a0, 8($sp)
            lw $ra, 4($sp)
            lw $fp, 0($sp)
            addi $sp, $sp, 12

        jr $ra

    # Tabuada function
    tabuada_func:
        addi $sp, $sp, -12
        sw $a0, 8($sp)
        sw $ra, 4($sp)
        sw $fp, 0($sp)
        move $fp, $sp

        la $a0, str_tabuada_res
        li $v0, 4
        syscall

        lw $a0, 8($fp)
        li $v0, 1
        syscall

        move $t6, $a0
        move $t5, $t6
        li $t7, 1
        li $t8, 10

        tabuada_loop: bgt $t7, $t8, return_tabuada
                      la $a0, str_new_line  # Print a new line
                      li $v0, 4
                      syscall

                      move $a0, $t5 # Print the argument
                      li $v0, 1
                      syscall

                      la $a0, str_times # Print " x "
                      li $v0, 4
                      syscall

                      move $a0, $t7 # Print the increment
                      li $v0, 1
                      syscall

                      la $a0, str_equal # Print " = "
                      li $v0, 4
                      syscall

                      move $a0, $t6 # Print the result (this line combined form: a x i = i*c)
                      li $v0, 1
                      syscall

                      add $t6, $t6, $t5 # Calculate the next result
                      addi $t7, $t7, 1  # Increment
                      j tabuada_loop

        return_tabuada:
            # Wait for the user press enter to see the result
            la $a0, str_continue
            li $v0, 4
            syscall

            la $a0, str_enter
            li $a1, 1
            li $v0, 8
            syscall

            lw $a0, 8($sp)
            lw $ra, 4($sp)
            lw $fp, 0($sp)
            addi $sp, $sp, 12

            jr $ra

    # Square root funtion (Babylonian method)
    square_root_func:
        addi $sp, $sp, -12
        s.s $f2, 8($sp) # $f2 = n (argument of function)
        sw $ra, 4($sp)
        sw $fp, 0($sp)
        move $fp, $sp

        l.s $f10, zero_fp    # Load 0.0 from memory
        c.lt.s $f2, $f10
        bc1t error_negative_square

        # Load constants
        l.s $f3, e_fp # Error constant
        l.s $f4, one_fp # $f4 = y
        l.s $f5, two_fp # Two constant used in loop

        mov.s $f6, $f2  # $f6 = x; (x = n)

        square_root_loop: sub.s $f7, $f6, $f4   # $f6 = (x - y)
                          c.lt.s $f7, $f3   # (x - y) < e
                          bc1t return_square_root
                          add.s $f6, $f6, $f4   # x = (x + y)
                          div.s $f6, $f6, $f5   # x = x / 2
                          div.s $f4, $f2, $f6   # y = n / x
                          mov.s $f0, $f6    # return value in $f0
                          j square_root_loop


        error_negative_square:
            la $a0, str_error_negative
            li $v0, 4
            syscall

            la $a0, str_continue
            syscall

            la $a0, str_enter
            li $a1, 1
            li $v0, 8
            syscall


    return_square_root:
            l.s $f2, 8($sp)
            lw $ra, 4($sp)
            lw $fp, 0($sp)
            addi $sp, $sp, 12

            jr $ra
