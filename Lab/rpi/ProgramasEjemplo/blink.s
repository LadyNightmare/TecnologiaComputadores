.data
leds:	.word RLED1, RLED2, YLED1, YLED2, GLED1, GLED2	/* id de los pines de los leds */

.include "wiringPiPins.h"  /* fichero con definiciones para el control de la placa */

.text
 
.global main
.func main
main:

	bl wiringPiSetup	/* inicializamos libreria */

						/* configuramos pin del pulsador 1 y 2 como entrada */	
						/* pinMode(int pin, int mode) */
	mov r0, #BUTTON1	/* indicamos el pin */	
	mov r1, #INPUT		/* indicamos el modo */
	bl pinMode			/* llamamos a la funcion pinMode */
	
	mov r0, #BUTTON2	/* indicamos el pin */	
	mov r1, #INPUT		/* indicamos el modo */
	bl pinMode			/* llamamos a la funcion pinMode */
						/* configuramos pines de leds como salidas */	
	ldr r5, =leds		/* cargamos en r5 la direccion del array con los pines de los leds */
	add r6, r5, #24		/* en r6 calculamos la direccion final del array (6*4) */
bconf:	
	ldr r0, [r5]		/* cargamos un pin */
	mov r1, #OUTPUT		/* indicamos el modo */
	bl pinMode			/* configuramos pin como salida */
						/* pinMode(int pin, int mode) */
	add r5, r5, #4		/* avanzamos el puntero que recorre el array de pines */
	cmp r5, r6			/* comprobamos si ha llegado al ultimo */
	bne bconf			/* si no ha llegado, volvemos para inicializar otro */
	
bucle:					/* bucle para el parpadeo del led */
						/* escribimos un 1 en el pin */
						/* digitalWrite(int pin, int value) */
	mov r0, #RLED1		/* indicamos el pin */
	mov r1, #1			/* ponemos el valor 1 */
	bl digitalWrite		/* llamamos a la funcion digitalWrite */
						/* esperamos medio segundo */
						/* delay(int ms) */
	mov r0, #500		/* indicamos el numero de milisegundos */		
	bl delay			/* llamamos a la funcion delay */
						/* escribimos el valor 0 */
	mov r0, #RLED1		/* indicamos el pin */
	mov r1, #0			/* ponemos el valor 0 */
	bl digitalWrite		/* llamamos a la funcion digitalWrite */
						/* esperamos medio segundo */
						/* delay(int ms) */
	mov r0, #500		/* indicamos el numero de milisegundos */		
	bl delay			/* llamamos a la funcion delay */
						/* leemos el estado del pulsador 1 */
						/* int digitalRead(int pin) */
	mov r0, #BUTTON1	/* indicamos el pin */
	bl digitalRead		/* llamamos a la funcion digitalRead */
	cmp r0, #0			/* vemos si el estado leido del pin es 0 */
	bne bucle			/* si no es 0, no se ha pulsado y volvemos a parpadear */

						/* syscall exit(int status) */
	mov     r0, #0     	/* status -> 0 */
	mov     r7, #1     	/* exit es syscall #1 */
	swi     #0          /* llamada a syscall */
