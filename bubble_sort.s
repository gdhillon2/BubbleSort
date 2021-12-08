/*
 * bubble_sort
 * input: r0 contains input string
 *	  r1 contains size of input string
 * output: sorted input string
 */

.global bubble_sort

bubble_sort:
	stmfd sp!, {r4, r5, r6, r8, r9, lr}

@ r5 = outerFor loop counter
	outer_count	.req r5
@ r6 = innerFor loop counter
	inner_count	.req r6
@ r1 = size - 1
	str_size	.req r1
	
	mov outer_count, #0
	sub str_size, str_size, #1

@ Makes the bubble sort go through the string size - 1 times
outerFor:
@ for ( r5 = 0; r5 < size - 1; ++r5 ) 
@ {
	mov inner_count, #0
	cmp outer_count, r1
	add outer_count, outer_count, #1
	blt innerFor
	bal exit
@ }

@ Goes through the string and sorts adjacent elements
innerFor:
@ for ( r6 = 0; r6 < size - 1; ++r6 )
@ {
	cmp inner_count, str_size
	bge outerFor

	ldrb r4, [r0, inner_count]
	add r9, inner_count, #1
	ldrb r8, [r0, r9]

	cmp r4, r8
@ if ( r4 > r8 )
@ {
	bhi switch
@ }
	add inner_count, inner_count, #1
	bal innerFor
@ }

@ Switches adjacent elements if first element is bigger than second
switch:
	strb r8, [r0, inner_count]
	strb r4, [r0, r9]
	add inner_count, inner_count, #1
	bal innerFor

exit:
	ldmfd sp!, {r4, r5, r6, r8, r9, pc} 
