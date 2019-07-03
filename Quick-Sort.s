.section .data
    V: .quad 2, 8, 7, 5, 1, 3, 4, 6, 9
    N: .quad 9
    str1: .string "%d\n"
.section .text

partition:
    pushq %rbp #registro de ativacao 
    movq %rsp, %rbp 
    pushq %rbx 
    movq %rsi, %rbx #Ac
    imulq $8, %rbx
    addq %rdx, %rbx
    movq %rdi, %rax
    subq $1, %rax
    movq %rdi, %rcx
    LOOP:
        cmpq %rcx, %rsi
        je END_LOOP
        movq %rcx, %r8
        imulq $8, %r8
        addq %rdx, %r8
        
        movq (%rbx), %r9
        cmpq (%r8), %r9
        jl END_IF_2
        
        incq %rax

        movq %rax, %r9
        imulq $8, %r9
        addq %rdx, %r9

        movq (%r9), %r10
        movq (%r8), %r11
        movq %r11, (%r9)
        movq %r10, (%r8)

        END_IF_2:
        incq %rcx
        jmp LOOP
    END_LOOP:
    
    movq %rax, %r9
    incq %r9
    imulq $8, %r9
    addq %rdx, %r9

    movq %rsi, %r8
    imulq $8, %r8
    addq %rdx, %r8

    movq (%r9), %r10
    movq (%r8), %r11
    movq %r11, (%r9)
    movq %r10, (%r8)

    popq %rbx
    popq %rbp
    inc %rax
    ret 

# rdi - Low 
# rsi - High
# rdx - Endereco do vetor
quick_sort:
    pushq %rbp
    movq %rsp, %rbp
    subq $8, %rsp

    cmpq %rdi, %rsi
    jle END_IF
        pushq %rdi
        pushq %rsi
        pushq %rdx
        call partition
        movq %rax, -8(%rbp)
        popq %rdx
        popq %rsi
        popq %rdi

        pushq %rdi
        pushq %rsi
        pushq %rdx
        movq -8(%rbp), %rsi
        subq $1, %rsi
        call quick_sort
        popq %rdx
        popq %rsi
        popq %rdi

        pushq %rdi
        pushq %rsi
        pushq %rdx
        movq -8(%rbp), %rdi
        incq %rdi
        call quick_sort
        popq %rdx
        popq %rsi
        popq %rdi
    END_IF:
    add $8, %rsp
    popq %rbp
ret

vector_printing:
	pushq %rbp
	movq %rsp, %rbp
	
    pushq %rbx
	pushq %r12
    
    movq $0, %rbx
	movq %rdi, %r12
    for:
        cmpq %rsi, %rbx
        jge end_for
        pushq %rsi
        pushq %rdi
        movq (%r12), %rsi
        movq $str1, %rdi
        call printf
        popq %rdi
        popq %rsi
        
        addq $8, %r12
        incq %rbx
        jmp for
    end_for:
        popq %r12
        popq %rbx
        popq %rbp
ret

.globl main
    main:
    movq %rsp, %rbp
	subq $8, %rsp
    
    movq $0, %rdi # Low
    movq N, %rsi # High
    subq $1, %rsi 
    movq $V, %rdx # Endereco do vetor 
    call quick_sort

    movq $V, %rdi
    movq N, %rsi
    call vector_printing
    addq $32, %rsp

	movq $60, %rax
syscall
