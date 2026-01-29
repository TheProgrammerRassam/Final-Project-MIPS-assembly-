.data
mainMenu: .asciiz "\n1- Fruits\n2- Meat\n3- Spices\n4- Exit\nYour choice: "
fruitMenu: .asciiz "\nFruits:\n1- Apple\n2- Banana\n3- Orange\nYour choice: "
meatMenu:  .asciiz "\nMeat:\n1- Beef\n2- Chicken\n3- Lamb\nYour choice: "
spiceMenu: .asciiz "\nSpices:\n1- Pepper\n2- Cumin\n3- Turmeric\nYour choice: "

totalMsg: .asciiz "\nTotal price = "
errorMsg: .asciiz "\nInvalid choice!\n"

# Price arrays
fruitPrices: .word 5, 3, 4
meatPrices:  .word 20, 15, 25
spicePrices: .word 2, 3, 4

total: .word 0

.text
.globl main

main:
main_loop:
    la $a0, mainMenu
    jal print_string
    jal read_int
    move $t0, $v0

    beq $t0, 1, fruit
    beq $t0, 2, meat
    beq $t0, 3, spice
    beq $t0, 4, finish
    j error

fruit:
    la $a0, fruitMenu
    jal print_string
    jal read_int
    move $a0, $v0
    la $a1, fruitPrices
    jal add_price
    j main_loop

meat:
    la $a0, meatMenu
    jal print_string
    jal read_int
    move $a0, $v0
    la $a1, meatPrices
    jal add_price
    j main_loop

spice:
    la $a0, spiceMenu
    jal print_string
    jal read_int
    move $a0, $v0
    la $a1, spicePrices
    jal add_price
    j main_loop

error:
    la $a0, errorMsg
    jal print_string
    j main_loop

finish:
    la $a0, totalMsg
    jal print_string
    lw $a0, total
    li $v0, 1
    syscall

    li $v0, 10
    syscall

# ================= FUNCTIONS =================

# print_string(a0)
print_string:
    li $v0, 4
    syscall
    jr $ra

# read_int -> v0
read_int:
    li $v0, 5
    syscall
    jr $ra

# add_price(index, array)
add_price:
    addi $sp, $sp, -8
    sw $ra, 4($sp)
    sw $a1, 0($sp)

    addi $a0, $a0, -1     # index--
    sll $a0, $a0, 2       # index * 4
    add $a1, $a1, $a0
    lw $t0, 0($a1)

    lw $t1, total
    add $t1, $t1, $t0
    sw $t1, total

    lw $ra, 4($sp)
    addi $sp, $sp, 8
    jr $ra
