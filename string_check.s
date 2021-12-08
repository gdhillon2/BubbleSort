/*
 * string_check
 * input: r0 contains input string
 * output: if there is punctuation, a message is printed to remove it and the program closes
 */

.global string_check

string_check:
	stmfd sp!, {r4, r5, r6, lr}

@ r4 = byte counter/pointer
	mov r4, #0
	byte_counter .req r4
@ r5 = current byte
	current_byte .req r5
loop:
@ while ( r5 != 10 )
@ {

@ Prints error message if string is longer than 19 characters
	cmp byte_counter, #20
@ if ( byte _counter == 20 )
@ {
	beq capErrorMSG
@ }

	ldrb current_byte, [r0, byte_counter]

@ checks if the character is a newline signifying end of string
	cmp current_byte, #10
@ if ( current_byte = newline )
@ {
	beq exit
@ }
	
@ checks if the character is a space
	cmp current_byte, #32
@ if ( current_byte = space )
@ {
	beq errorMSG
@ }

@ checks if there is a character lower than ASCII value 48
	cmp current_byte, #48
@ if ( current_byte < 48 )
@ {
	blt errorMSG
@ }

@ checks if there is a character higher than ASCII value 122
	cmp current_byte, #122
@ if ( current_byte > 122 )
@ {
	bhi errorMSG
@ }

@ checks if there is a character between 91 and 96 ASCII values
	sub r6, current_byte, #91
	cmp r6, #5
@ if ( current_byte >= 91 && current_byte <= 96 )
@ {
	bls errorMSG
@ }

@ checks if there is a character 58 and 64
	sub r6, current_byte, #58
	cmp r6, #6
@ if ( current_byte >= 58 && current_byte <= 64 )
@ {
	bls errorMSG
@ }

	add byte_counter, byte_counter, #1
	bal loop
@ }

@ prints character limit error message
capErrorMSG:
	ldr r0, =cap
	bl printf
	
	mov r7, #1
	swi 0

@ prints punctuation and spaces error message
errorMSG:
	ldr r0, =oops
	bl printf

	mov r7, #1
	swi 0

exit:
	ldmfd sp!, {r4, r5, r6, pc}


.data
oops:
	.asciz "Punctuation and spaces must be removed before inputting string.\n"
cap:
	.asciz "Please enter only 19 characters or less.\n"
