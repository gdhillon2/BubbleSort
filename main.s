	.global main
main:
@ Prompts user for input string
	ldr r0, =prompt
	bl printf

@ Reads input string from user
	mov r0, #0
	mov r2, #20
	mov r7, #3
	ldr r1, =inputString
	swi 0

@ r4 = byte counter/pointer
	byte_count	.req r4
@ r1 = pointer to input string
	input_string	.req r1
@ r5 = character being checked
	curr_char	.req r5
@ r6 = counter to check how many non-space characters there are
	char_count	.req r6

	mov char_count, #0
	mov byte_count, #0
	ldr input_string, =inputString

@ Calculates the length of the input string + 1
lengthCalc:
@ while ( byte_count < 20 )
@ {
	ldrb curr_char, [input_string, byte_count]

@ adds 1 to char_count for every non-space character in the string
	cmp curr_char, #32
	addne char_count, char_count, #1
	addne byte_count, byte_count, #1
	bne recursion

@ checks to make sure byte count doesn't go above max character limit
	cmp byte_count, #20
	addlt byte_count, byte_count, #1
	blt lengthCalc
	bal lengthCheck
@ }

@ checks to make sure r4 counter stays below max limit of input string
recursion:
	cmp byte_count, #20
	blt lengthCalc
	bal lengthCheck

@ checks length of string to make sure it's more than 1 inputted character
lengthCheck:

	cmp char_count, #2
	beq lengthError
	bal puncCheck

@ prints length error message
lengthError:
	ldr r0, =lengthErrorMsg
	bl printf
	bal main

@ Loads string into r0 and calls string_check to make sure there's no punctuation in it
puncCheck:
	ldr r0, =inputString
	bl string_check

@ Inputs input string into r0 and size of string into r1 and calls bubble_sort
	sub r1, r6, #1
	bl bubble_sort

@ Prints "Sorted String: " prompt
	ldr r0, =sortedStringPrompt
	bl printf

@ Prints sorted input string
	ldr r0, =inputString
	bl printf

outputFile:
@ writes output file
	ldr r0, =outputPath
	ldr r1, =writeMode
	bl fopen
	mov r8, r0

@ r0 = output string
	output_string	.req r0
	ldr output_string, =outputString
	ldr input_string, =inputString

@ Resets byte counter
	mov byte_count, #0

@ r2 = current byte of inputString
	input_curr	.req r2

@ Writes new output string that doesn't contain newline character so there isn't an extra line in output file
writeLoop:
	ldrb input_curr, [input_string, byte_count]
	cmp input_curr, #10
	beq writeFile
	strb input_curr, [output_string, byte_count]
	add byte_count, byte_count, #1
	bne writeLoop

@ Writes outputString to output.txt file
writeFile:
	ldr r0, =outputString
	mov r1, r8
	bl fputs

@ Closes output.txt file
closeFile:
@ closes file being written

	mov r0, r8
	bl fclose

exit:
	mov r7, #1
	swi 0
.data
prompt:
	.asciz "Please enter a string to sort: \n"
inputString:
	.asciz "                     "
outputString:
	.asciz "                     "
lengthErrorMsg:
	.asciz "Please enter two or more characters.\n"
sortedStringPrompt:
	.asciz "Sorted String: "
outputPath:
	.asciz "output.txt"
writeMode:
	.asciz "w"
