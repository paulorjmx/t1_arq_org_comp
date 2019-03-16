# Autor: Paulo Ricardo Jordao Miranda
# Trabalho entregue como requisito à disciplina de Arquitetura e Organização de Computadores


.data
    str_title:  .asciiz "Bem-vindo a Calculadora Assembly\n\n"
    str_choose: .asciiz "Escolha uma das opcoes abaixo\n\n"
    str_op1:    .asciiz "[1] Soma\n"
    str_op2:    .asciiz "[2] Subtracao\n"
    str_op3:    .asciiz "[3] Multiplicacao\n"
    str_op4:    .asciiz "[4] Divisao\n"
    str_op5:    .asciiz "[5] Potencia\n"
    str_op6:    .asciiz "[6] IMC (Indice de Massa Corporal)\n"
    str_op7:    .asciiz "[7] Sequencia de Fibonnaci\n"
    str_op8:    .asciiz "[8] Raiz Quadrada\n"
    str_op9:    .asciiz "[9] Tabuada de um numero\n"
    str_op10:   .asciiz "[10] Fatorial\n"
    str_op11:   .asciiz "[11] Sair\n\n"
    str_usr_in: .asciiz "-> "
    str_op1_in: .asciiz "Entre com o primeiro operando: "
    str_op2_in: .asciiz "\nEntre com o segundo operando: "
    str_error_choice:   .asciiz "\nErro: Escolha uma opcao valida!\n"
    str_continue:   .asciiz "\n(Aperte Enter para continuar)\n"
    str_enter:  .byte
    #str_res: .asciiz "Escolha: "

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
        move $t2, $v0

        # Print: Type the second operand
        la $a0, str_op2_in
        li $v0, 4
        syscall

        # Gets the second operand
        li $v0, 5
        move $t3, $v0

        

    soma:
        move $a0, $t2   # Put the first argument in $a0
        move $a1, $t3   # Put the second argument in $a1
        jal soma_func



    others_ops:
        li $t1, 11
        bge $t0, $t1, exit  # if($t0 > 11) exits. If the user choice is greater or equal 11


    # Prints the error on screen and go to menu
    error_choice:
        la $a0, str_error_choice
        li $v0, 4
        syscall

        la $a0, str_continue
        li $v0, 4
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



    # Print the menu, and return the user choice in $v0
    print_menu:
        addi $sp, $sp, -8
        sw $ra, 0($sp)
        sw $fp, -4($sp)
        move $fp, $sp

        la $a0, str_choose
        li $v0, 4
        syscall

        la $a0, str_op1
        li $v0, 4
        syscall

        la $a0, str_op2
        li $v0, 4
        syscall

        la $a0, str_op3
        li $v0, 4
        syscall

        la $a0, str_op4
        li $v0, 4
        syscall

        la $a0, str_op5
        li $v0, 4
        syscall

        la $a0, str_op6
        li $v0, 4
        syscall

        la $a0, str_op7
        li $v0, 4
        syscall

        la $a0, str_op8
        li $v0, 4
        syscall

        la $a0, str_op9
        li $v0, 4
        syscall

        la $a0, str_op10
        li $v0, 4
        syscall

        la $a0, str_op11
        li $v0, 4
        syscall

        la $a0, str_usr_in
        li $v0, 4
        syscall

        # Reads the user choice
        li $v0, 5
        syscall

        lw $ra, 0($sp)
        lw $fp, -4($sp)
        addi $sp, $sp, 8
        jr $ra


    # Sum of two numbers
    soma_func:
        addi $sp, $sp, -12
        sw $a0, 12($sp)
        sw $a1, 8($sp)
        sw $ra, 4($sp)
        sw $fp, 0($sp)

        add $v0, $a0, $a1

        lw $a0, 12($sp)
        lw $a1, 8($sp)
        lw $ra, 4($sp)
        lw $fp 0($sp)

        jr $ra
