.data
leds:	.word RLED1, RLED2, YLED1, YLED2, GLED1, GLED2	/* led pin id */

.include "wiringPiPins.s"  /* contains control definitions for the board */

.text
 
.global main
.func main
main:
/************************************************************************************/
/* Library wiringPi configuration of led and button pins and speaker */
/************************************************************** **********************/

	bl wiringPiSetup	/* initialize library */

						/* configure button 1 and 2 pin as input */	
						/* pinMode(int pin, int mode) */
	mov r0, #BUTTON1	 /* give pin */	
	mov r1, #INPUT		/* give mode */
	bl pinMode			/* call pinMode */
	
	mov r0, #BUTTON2	/* give pin */	
	mov r1, #INPUT		/* give mode */
	bl pinMode			/* call pinMode */
						/* configure speaker pin as output */	
	mov r0, #BUZZER		/* give pin */	
	mov r1, #OUTPUT		/* give mode */
	bl pinMode			/* call pinMode */
						/* configure led pins as output */	
	ldr r5, =leds		/* load r5 with array direction of the led pins */
	add r6, r5, #24		/* put in r6 the address of the end of the array (6*4) */
bconf:	
	ldr r0, [r5]		/* load pin */
	mov r1, #OUTPUT		/* give mode */
	bl pinMode			/* configure pin as output */
						/* pinMode(int pin, int mode) */
	add r5, r5, #4		/* increase pin counter */
	cmp r5, r6			/* check we reached the last one */
	bne bconf			/* if not, let us initialize another one */
	
loop:					/* loop for led blinking */
						/* write a 1 in a pin pin */
						/* digitalWrite(int pin, int value) */
	mov r0, #RLED1		/* give pin */
	mov r1, #1			/* put value 1 */
	bl digitalWrite		/* call digitalWrite */
						/* wait half a second */
						/* delay(int ms) */
	mov r0, #500		/* give number of milliseconds */		
	bl delay			/* call delay */
						/* write a 0 */
	mov r0, #RLED1		/* give pin */
	mov r1, #0			/* put 0 value*/
	bl digitalWrite		/* call digitalWrite */
						/* wait half a second */
						/* delay(int ms) */
	mov r0, #500		/* give number of milliseconds */		
	bl delay			/* call delay */
						/* read button state */
						/* int digitalRead(int pin) */
	mov r0, #BUTTON1	/* give pin */
	bl digitalRead		/* call digitalRead */
	cmp r0, #0			/* check pin state is 0 */
	beq out			    /* on 0, someone pushed the out-button!!! */
	mov r0, #BUTTON2	/* give pin */
	bl digitalRead		/* call digitalRead */
	cmp r0, #0			/* check pin state is 0 */
	bne loop			/* if not 0, no button pushed, continue blinking */

out:					/* syscall exit(int status) */
	mov     r0, #0     	/* status -> 0 */
	mov     r7, #1     	/* exit is syscall #1 */
	swi     #0          /* call syscall */
