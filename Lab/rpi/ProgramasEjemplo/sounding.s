.data
var1: 	.asciz "Delay %d microseg\012"		//* printf string on  delay change */
leds:	.word RLED1, RLED2, YLED1, YLED2, GLED1, GLED2	/* led pin id  */
del:	.word 800							/* initial delay */


.include "wiringPiPins.s"	/* defines board control */

.text
 
.global main
.func main
main:

	bl wiringPiSetup	/* initialize library */
						/* configure button 1 and 2 pin as input */	
	mov r0, #BUTTON1	/* give pin */	
	mov r1, #INPUT		/* give mode */
	bl pinMode			/* call pinMode */
							
	mov r0, #BUTTON2	/* configure pin of button 2 as input */	
	mov r1, #INPUT		
	bl pinMode			

	mov r0, #BUZZER		/* configure speaker pin as output */
	mov r1, #OUTPUT
	bl pinMode
						
	ldr r5, =del		/* load sound delay between states 0 and 1 in r6 */
	ldr r6, [r5]

loop:					/* loop to make noise sending a pulse chain */
	mov r0, #BUZZER		/* put value 1 in speaker with digitalWrite */
	mov r1, #1
	bl digitalWrite

	mov r0, r6			/* wait r6 microseconds */
	bl delayMicroseconds

	mov r0, #BUZZER		/* during wait put 0 in speaker */
	mov r1, #0
	bl digitalWrite

	mov r0, r6			/* wait again r6 microseconds */
	bl delayMicroseconds

	mov r0, #BUTTON1	/* read button 1 state with digitalRead */
	bl digitalRead
	cmp r0, #0			/* check it is 0 */
	beq up			/* if so, someone pushed the button we increase delay */

	mov r0, #BUTTON2	/* read button 2 state with digitalRead */
	bl digitalRead
	cmp r0, #0			/* check it is 0 */
	beq down			/* if so, someone pushed the button we decrease delay */
	b loop
	
up:					 /* increase sound delay between states 0 and 1 in r6 by 1 */
    cmp r6, #2000
    bge loop
	add r6, r6, #1
	ldr r0, =var1		/* print new delay */
	mov r1, r6
	bl printf
	b loop				/* return to loop */

down:					/* decrease sound delay between states 0 and 1 in r6 by 1  */
    cmp r6, #0
    ble loop
	add r6, r6, #-1
	ldr r0, =var1		/* print new delay */
	mov r1, r6
	bl printf
	b loop   			/* return to loop */
	
						/* syscall exit(int status) */
out:	
	mov     r0, #0     	/* status -> 0 */
	mov     r7, #1     	/* exit is syscall #1 */
	swi     #0         	/* syscall */


