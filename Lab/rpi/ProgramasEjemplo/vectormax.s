.data			// seccion de datos

msg:	.asciz  "El maximo del vector es: %d\n"	// Cadena para printf
vector:	.word	4, -2, 5, -6, 7, -7, 9, 1		// Vector de enteros	
tam:	.word	8								// tam del vector

.text			// seccion de codigo

.global main	
.func main
main:
    ldr		r4, =vector			// carga en r4 dir del vector
    ldr 	r5, =tam			// carga en r5 dir de tam
    ldr		r5, [r5]			// carga en r5 el contenido de tam
    cmp		r5, #0				// coparamos tam con 0
	beq		salir				// si es 0, terminamos
	ldr		r6, [r4]			// cargamos el primer valor del vector
	add		r4, r4, #4			// avanzamos el puntero de lectura
	subs 	r5, r5, #1			// restamos 1 al nuero de elem. a leer
loop:
	beq		salir				// si es 0 la ultima resta, terminamos
	ldr		r1, [r4]			// cargamos otro dato del vector
    cmp		r6, r1				// lo comparamos con el maximo (r6)
    bpl		cont				// si es mayor o igual a 0, continuamos
    mov		r6, r1				// si no, el valor leido es el nuevo max
cont:
	add		r4, r4, #4			// avanzamos el puntero de lectura
	subs	r5, r5, #1			// restamos 1 al numero de elem. a leer
    b 		loop				// volmemos al comienzo del bucle
 
 salir:   
    ldr     r0, =msg   			// cargamos dir del mensaje para printf
    mov		r1, r6 				// cargamos valor primer parametro printf
    bl 		printf				// llamamos a la funcion printf
    /* syscall exit(int status) */
    mov     r0, #0     /* status -> 0 */
    mov     r7, #1     /* exit is syscall #1 */
    swi     #0          /* invoke syscall */
    
