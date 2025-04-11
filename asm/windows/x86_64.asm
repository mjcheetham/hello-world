.section .data
    message: .asciz "Hello, World!\n"  # The string to print
    msg_len: .quad 14                 # Length of the message

.section .text
    .global _start
    .extern GetStdHandle
    .extern WriteFile
    .extern ExitProcess

_start:
    # Get the handle for stdout
    movq $-11, %rcx                   # STD_OUTPUT_HANDLE (-11)
    call GetStdHandle                 # GetStdHandle(STD_OUTPUT_HANDLE)
    movq %rax, %rbx                   # Save the handle in %rbx

    # Write the message to stdout
    leaq message(%rip), %rdx          # Pointer to the message
    movq msg_len(%rip), %r8           # Length of the message
    subq $48, %rsp                    # Allocate shadow space + space for OVERLAPPED
    leaq (%rsp), %r9                  # Pointer to bytes written (dummy)
    movq %rbx, %rcx                   # Handle (stdout)
    movq $0, (%rsp)                   # Push NULL for OVERLAPPED
    call WriteFile                    # WriteFile(stdout, message, msg_len, &bytes_written, NULL)
    addq $48, %rsp                    # Deallocate shadow space + OVERLAPPED space

    # Exit the program
    subq $8, %rsp                     # Align stack to 16 bytes
    xorq %rcx, %rcx                   # Exit code: 0
    call ExitProcess                  # ExitProcess(0)
