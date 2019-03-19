# Autor: Paulo Ricardo Jordao Miranda
# Trabalho entregue como requisito à disciplina de Arquitetura e Organização de Computadores


.data
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
    str_op1_in: .asciiz "Entre com o primeiro operando: "
    str_op2_in: .asciiz "\nEntre com o segundo operando: "
    str_error_choice:   .asciiz "\nErro: Escolha uma opcao valida!\n"
    str_error_zero_div: .asciiz "\nErro: O divisor tem de ser diferente de zero.\n"
    str_error_negative_exp: .asciiz "\nErro: O expoente nao pode ser negativo.\n"
    str_error_overflow: .asciiz "\nErro: Digite um numero entre -32768 e 32767\n"
    str_continue:   .asciiz "\n(Aperte Enter para continuar)\n"
    str_enter:  .byte
    str_res: .asciiz "\nResultado: "

.text

.globl main

    main:
        la $a0, str_title
        li $v0, 4
        syscall

    user_choose: jal print_menu

        # Puts the user choice in $t0
        move $t0, $v0
        li $t1, 7
        bgt $t0, $t1, others_ops    # if($t0 > 7) If the user choice is greater than 7
        li $t1, 1
        blt $t0, $t1, error_choice  # if($t0 < 1) If the user choice is negative or invalid

    #seven_first_op:
        # Print: Type the first operand
        la $a0, str_op1_in
        li $v0, 4
        syscall

        # Gets the first operand
        li $v0, 5
        syscall
        move $t2, $v0

        # Print: Type the second operand
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
        li $t1, 6
        beq $t0, $t1, imc
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

        li $t7, -1
        beq $v0, $t7, user_choose   # If an error occurs

        move $a0, $v0
        jal print_result

        j user_choose

    divisao:
        move $a0, $t2
        move $a1, $t3
        jal divisao_func

        li $t7, -1
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
        move $a0, $t2
        move $a1, $t3
        jal imc_func

        move $a0, $v0
        jal print_result

        j user_choose

    fibonacci:



    others_ops:
        li $t1, 11
        bge $t0, $t1, exit  # if($t0 > 11) exits. If the user choice is greater or equal 11


    # Prints the error on screen and go to menu
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

    # Print result
    print_result:
        addi $sp, $sp, -12
        sw $a0, 8($sp)
        sw $ra, 4($sp)
        sw $fp, 0($sp)
        move $fp, $sp

        la $a0, str_res
        li $v0, 4
        syscall

        lw $a0, 8($fp)
        li $v0, 1
        syscall

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

            li $v0, -1  # Error return

    return_mult:
        lw $a1, 12($sp)
        lw $a0, 8($sp)
        lw $ra, 4($sp)
        lw $fp, 0($sp)
        addi $sp, $sp, 16

        jr $ra

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

            li $v0, -1  # Error on operation
            j return_div

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

            li $v0, -1  # Error on operation

    return_div:
        lw $a1, 12($sp)
        lw $a0, 8($sp)
        lw $ra, 4($sp)
        lw $fp, 0($sp)
        addi $sp, $sp, 16

        jr $ra

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

    imc_func:
        addi $sp, $sp, -16
        sw $a1, 12($sp)
        sw $a0, 8($sp)
        sw $ra, 4($sp)
        sw $fp, 0($sp)
        move $fp, $sp

        mul $a1, $a1, $a1
        div $v0, $a0, $a1

        lw $a1, 12($sp)
        lw $a0, 8($sp)
        lw $ra, 4($sp)
        lw $fp 0($sp)
        addi $sp, $sp, 16

        jr $ra
