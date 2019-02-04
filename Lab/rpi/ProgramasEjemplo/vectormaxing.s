.data			// data section

msg:	.asciz  "The vector máximum is: %d\n"	// printf string
vector:	.word	4, -2, 5, -6, 7, -7, 9, 1		// integer v	
numel:	.word	8								// number of elements

.text			// code section

.global main	
.func main
main:
    ldr		r4, =vector			// load vector address into r4 
    ldr 	r5, =numel			// load numel address into r5
    ldr		r5, [r5]			// load numel itself into r5 
    cmp		r5, #0				// check numel is 0
	beq		out					// if so, go out
	ldr		r6, [r4]			// cargamos el primer valor del vector
	add		r4, r4, #4			// increase read counter
	subs 	r5, r5, #1			// decrease numel still to be read
loop:
	beq		out					// if 0, lets go out
	ldr		r1, [r4]			// load next vector element
    cmp		r6, r1				// compare to current maximum r6
    bpl		cont				// if not, contiue
    mov		r6, r1			// if yes store new maximum
cont:
	add		r4, r4, #4			// increase read counter 
	subs	r5, r5, #1			// decrease numel still to be read 
    b 		loop				// lets go back 
out:   
    ldr     r0, =msg   			// read print message address
    mov		r1, r6 				// load print argument
    bl 		printf				// call printf
    /* syscall exit(int status) */
    mov     r0, #0     /* status -> 0 */
    mov     r7, #1     /* exit is syscall #1 */
    swi     #0          /* invoke syscall */
    
