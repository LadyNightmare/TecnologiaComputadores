.data
var1: 	.asciz "Delay %d microseg\012"		/* Cadena para printf cuando se cambia delay */
leds:	.word RLED1, RLED2, YLED1, YLED2, GLED1, GLED2	/* id de los pines de los leds */
del:	.word 800							/* delay inicia. */

.include "wiringPiPins.h"	/* fichero con definiciones para el control de la placa */				

.text
 
.global main
.func main
main:

	bl wiringPiSetup	/* inicializamos libreria */
						/* configuramos pin del pulsador 1 como entrada */	
	mov r0, #BUTTON1	/* indicamos el pin */	
	mov r1, #INPUT		/* indicamos el modo */
	bl pinMode			/* llamamos a la funcion pinMode */
							
	mov r0, #BUTTON2	/* configuramos pin del pulsador 2 como entrada */	
	mov r1, #INPUT		
	bl pinMode			

	mov r0, #BUZZER		/* configuramos el altavoz como salida */
	mov r1, #OUTPUT
	bl pinMode
						
	ldr r5, =del		/* cargamos en r6 el delay (espera) entre 0 y 1 del tren de pulsos a mandar al altavoz */
	ldr r6, [r5]

bucle:					/* bucle para hacer sonar altavoz mandando tren de pulsos */
	mov r0, #BUZZER		/* ponemos un 1 en el altavoz con digitalWrite */
	mov r1, #1
	bl digitalWrite

	mov r0, r6			/* esperamos el tiempo en microsengudos especificado en r6, con delayMicroseconds */
	bl delayMicroseconds

	mov r0, #BUZZER		/* tras la espera, ponemos a 0 el altavoz con digitalWrite */
	mov r1, #0
	bl digitalWrite

	mov r0, r6			/* volvemos a esperar el tiempo indicado en r6 */
	bl delayMicroseconds

	mov r0, #BUTTON1	/* leemos el estado del boton 1 con digitalRead */
	bl digitalRead
	cmp r0, #0			/* vemos si el estado leido del pin es 0 */
	beq sube			/* si es 0, se ha pulsado y saltamos para subir el retraso */

	mov r0, #BUTTON2	/* leemos el estado del boton 2 con digitalRead */
	bl digitalRead
	cmp r0, #0			/* vemos si el estado leido del pin es 0 */
	beq baja			/* si es 0, se ha pulsado y saltamos para bajar el retraso */
	b bucle
	
sube:					/* aumentamos el retraso entre 0 y 1 del tren de pulsos, sumando 1 a r6 */
    cmp r6, #2000
    bge bucle
	add r6, r6, #1
	ldr r0, =var1		/* imprimimos el nuevo retraso */
	mov r1, r6
	bl printf
	b bucle				/* volvemos al bucle */

baja:					/* disminuimos el retraso entre 0 y 1 del tren de pulsos, sumando 1 a r6 */
    cmp r6, #0
    ble bucle
	add r6, r6, #-1
	ldr r0, =var1		/* imprimimos el nuevo retraso */
	mov r1, r6
	bl printf
	b bucle   			/* volvemos al bucle */
	
						/* syscall exit(int status) */
salir:	
	mov     r0, #0     	/* status -> 0 */
	mov     r7, #1     	/* exit es syscall #1 */
	swi     #0         	/* llamada a syscall */

