		.data			# BOARD[i]:
BOARD:		.space	42		#	5	11	17	23	29	35	41
					#	4	10	16	22	28	34	40
					#	3	9	15	21	27	33	39
					#	2	8	14	20	26	32	38
					#	1	7	13	19	25	31	37
					#	0	6	12	18	24	30	36
		.align	2
HEIGHT:		.space	28
name1:		.space	50
name2:		.space	50
INPUTBYTE:	.space	4	
undocountp1:	.word	3
undocountp2:	.word	3

intro1:		.asciiz "\nWelcome to FOUR IN A ROW!\n\n[Created by duc.nguyen@hcmut.edu.vn - Nguyen Phan Tri Duc - 2152528 - 30/11/2022]\n\nPlease follow the instruction carefully and input only integer when required.\n"
askname1:	.asciiz "Player 1, please enter your name, maximum length is 30: "
askname2:	.asciiz "Player 2, please enter your name, maximum length is 30: "
doneinit1:	.asciiz "Player "
doneinit2:	.asciiz " will move first, please choose your character 'X' or 'O': "
doneinit3:	.asciiz " will be the second player, you will playing "
doneinit4:	.asciiz ", enter something to start the game: "
invalidXO:	.asciiz	"! Just accept 'X' or 'O' ! Please enter again: "
title:		.asciiz	" FOUR IN A ROW "
end1:		.asciiz	"! Congratulation "
end2:		.asciiz ", has won the game !\n"
draww:		.asciiz "! It's a draw, well done both players !"
askline1:	.asciiz	"It's " 
askline2:	.asciiz "'s turn, you are playing ["
askline3:	.asciiz "], enter the line you want to drop: "
askundo1:	.asciiz "Do you want to undo your movement? Type 'Y' or 'N', you have "
askundo2:	.asciiz " undo(s) left: "
askundoinput:	.asciiz	"Now enter the line you want to drop again: "

outofrange:	.asciiz "! Just allow input number from 1 to 7 ! Please enter again, if you input "
maxheight:	.asciiz	"! This column is full ! Please enter again, if you input "
invalidYN:	.asciiz	"! Just accept 'Y' or 'N' ! Please enter again: "
warn:		.asciiz	" more invalid column number, you will lose the game: "

blank:		.asciiz	" "
endl:		.asciiz "\n"
wall:		.asciiz	"|"
p1char:		.space	4
p2char:		.space	4
inputsign:	.asciiz	">> "
playing:	.asciiz ", playing "
smallfloor:	.asciiz	"---------------"
bigfloor:	.asciiz	"-----------------"

		.text

main:		jal	init
    		jal	printboard
		beq	$v1,	1,	p2TURN			#p2 first if random%2==1, else default p1 first
		
    	game:		beq	$s0,	42,	draw
    			jal 	movep1
    			jal	printboard
    			addi	$s0,	$s0,	1
    			
    		p2TURN:	beq	$s0,	42,	draw
    			jal	movep2
    			jal	printboard
    			addi	$s0,	$s0,	1
    			
    			j	game	
    			
    	endgame:jal	printboard
    		
    		la 	$a0, 	end1    
    		li 	$v0, 	4
    		syscall
    	
    		beq	$s1,	1,	p1WIN		#s1 from CHECKWIN
    		beq	$s1,	2,	p2WIN
    	
    		p1WIN:	la 	$a0, 	name1 
    		 	li 	$v0, 	4
    		 	syscall
    		 	la 	$a0, 	playing 
    		 	syscall
    			la 	$a0, 	p1char  
    			syscall
    			j	ENDDDD
    		p2WIN:	la 	$a0, 	name2
    		 	li 	$v0, 	4
    		 	syscall
    		 	la 	$a0, 	playing 
    		 	syscall
    			la 	$a0, 	p2char
    			syscall
    			j	ENDDDD
    			
    	ENDDDD:	la 	$a0, 	end2   
    		li 	$v0, 	4
    		syscall
		
    		li 	$v0, 	10      # end program
    		syscall
    	
    	
    	
    	draw:	la 	$a0, 	draww    
    		li 	$v0, 	4
    		syscall
    		
    		li 	$v0, 	10      # end program
    		syscall
    		
    		########

init:		li	$v0,	41
		syscall
		move	$v1,	$a0
		and	$v1,	$v1,	1

		la 	$a0, 	bigfloor  
		li 	$v0, 	4
    		syscall
    		syscall
    		syscall
    		syscall
    		syscall
		la 	$a0, 	intro1  
    		syscall
    		la 	$a0, 	bigfloor  
    		syscall
    		syscall
    		syscall
    		syscall
    		syscall
    		la 	$a0, 	endl  
    		syscall

    		la 	$a0, 	askname1    
    		syscall
    		la 	$a0, 	endl    
    		syscall
    		la 	$a0, 	inputsign    
    		syscall
    		
    		li 	$v0, 	8       #scanf
    		la 	$a0, 	name1  
    		li 	$a1, 	50      
    		syscall
    		
    	searchnewline1:	lb 	$t0, 	($a0)						#process to remove new line character
    			beq 	$t0, 	'\n', 	endsearch1 
    			addi 	$a0,	$a0, 	1
    			j	searchnewline1   
	endsearch1:	sb 	$0, 	($a0) 

    		la 	$a0, 	askname2    
    		li 	$v0, 	4
    		syscall
    		la 	$a0, 	endl    
    		syscall
    		la 	$a0, 	inputsign    
    		syscall
    		
    		li 	$v0, 	8       #scanf
    		la 	$a0, 	name2
    		li 	$a1, 	50
    		syscall
    		
    	searchnewline2:	lb 	$t0, 	($a0)						#process to remove new line character
    			beq 	$t0, 	'\n', 	endsearch2 
    			addi 	$a0,	$a0, 	1
    			j	searchnewline2   
	endsearch2:	sb 	$0, 	($a0) 
    		
    		li	$s0,	0	#count how many moves have been done		#now s0 is the move counter
    		
    		li	$t0,	0
    		la	$t1,	BOARD
    		
    	init0:		beq	$t0,	42,	endinit0				#initialize all BOARD values to 0
    			sb	$0,	0($t1)
    			addi	$t1,	$t1,	1
    			addi	$t0,	$t0,	1
    			j 	init0
    	endinit0:	
    		
    		li	$t0,	0
    		la	$t1,	HEIGHT
    		
    	inith0:		beq	$t0,	7,	endinith0				#initialize all HEIGHT values to 0
    			sw	$0,	0($t1)
    			addi	$t1,	$t1,	4
    			addi	$t0,	$t0,	1
    			j 	inith0
    	endinith0:	
    	
    		li	$t1,	3
    		la	$t0,	undocountp1
    		sw	$t1,	($t0)
    		la	$t0,	undocountp2
    		sw	$t1,	($t0)
    		
    		li 	$v0, 	4
    		la 	$a0, 	doneinit1    
    		syscall
    
    		beq	$v1,	0,	p1first
    		
    	p2first:la 	$t3, 	name2			#t3 holds the address of first player name
    		la	$t4,	name1			#t4 holds the address of second player name
    		la	$t1,	p2char			#t1 holds the address of first player char	
    		la	$t2,	p1char			#t2 holds the address of second player char	
    		move	$a0,	$t3
    		j	donechoosechar
    		    
    	p1first:la 	$t3, 	name1   
    		la	$t4,	name2
    		la	$t1,	p1char
    		la	$t2,	p2char
    		move	$a0,	$t3
    		
    	donechoosechar:
    		syscall					
    		
    		la 	$a0, 	doneinit2  
    		syscall
    		
    		la 	$a0, 	endl    
    		syscall
    		la 	$a0, 	inputsign   
    		syscall
    		
    	scanXO:	li 	$v0, 	8       		#scanf
		la 	$a0, 	INPUTBYTE  		
    		li 	$a1, 	4      			
    		syscall					
    		
    		la	$t0,	INPUTBYTE		
    		lb	$t0,	($t0)			
    		beq	$t0,	'X',	chosenX		
    		beq	$t0,	'O',	chosenO	
    			
    		li 	$v0, 	4			
    	 	la 	$a0, 	invalidXO		
    	 	syscall
    	 	la 	$a0, 	endl    
    		syscall
    		la 	$a0, 	inputsign    
    		syscall		
    	 	j	scanXO				
    	 	
    	 chosenX:	sb	$t0,	($t1)
    	 		li	$t5,	'O'
    	 		sb	$t5,	($t2)
    	 		j	doneChosenXO
    	 		
    	 chosenO:	sb	$t0,	($t1)
    	 		li	$t5,	'X'
    	 		sb	$t5,	($t2)
    	 
    	 doneChosenXO:
    	 	li 	$v0, 	4
    	 	la 	$a0, 	doneinit1    
    		syscall
    		move 	$a0, 	$t4    
    		syscall
    		la 	$a0, 	doneinit3    
    		syscall
    		move 	$a0, 	$t2    
    		syscall
    		la 	$a0, 	doneinit4
    		syscall
    		la 	$a0, 	endl
    		syscall
    		la 	$a0, 	inputsign
    		syscall
    		
    		li 	$v0, 	8       		#scanf
		la 	$a0, 	intro1  		
    		li 	$a1, 	30    			
    		syscall		
    		
		jr	$ra
		
printboard:	li 	$v0, 	4
		la 	$a0, 	wall    
    		syscall
		la 	$a0, 	bigfloor    
    		syscall
    		la 	$a0, 	wall    
    		syscall
    		la 	$a0, 	endl    
    		syscall
    		la 	$a0, 	wall    
    		syscall
    		syscall
    		la 	$a0, 	title    
    		syscall
    		la 	$a0, 	wall    
    		syscall
    		syscall
    		la 	$a0, 	endl    
    		syscall
    		la 	$a0, 	wall    
    		syscall
    		syscall
    		la 	$a0, 	smallfloor    
    		syscall
    		la 	$a0, 	wall    
    		syscall
    		syscall
    		la 	$a0, 	endl    
    		syscall
    		
    		li	$t1,	5
    		la	$t6,	BOARD	
    		li	$t7,	6					#const 6	
    		
    		
    	OLp:		beq	$t1,	-1,	endOLp			#outer loop print
    			li	$t0,	0
    			
    			li 	$v0, 	4
			la 	$a0, 	wall    
    			syscall
    			syscall
    			la 	$a0, 	blank    
    			syscall
    			
    		ILp:		beq	$t0,	7,	endILp			#inner loop print
    				mul 	$t2,	$t7,	$t0
    				add	$t2,	$t2,	$t1					#t2=6*t0 + t1
    				add	$t5,	$t2,	$t6					#BOARD[t2]=BOARD+t2
    		
    				lb	$t4,	($t5)
    				beq	$t4,	0,	PRINTBLANK
    				beq	$t4,	1,	PRINTp1char
    				beq	$t4,	2,	PRINTp2char
    				
    			PRINTBLANK:	li	$v0,	4
    					la	$a0,	blank
    					syscall
    					j	DONEPRINT
    			PRINTp1char:	li	$v0,	4
    					la	$a0,	p1char
    					syscall
    					j	DONEPRINT
    			PRINTp2char:	li	$v0,	4
    					la	$a0,	p2char
    					syscall
    					j	DONEPRINT
    				
    			DONEPRINT:	li 	$v0, 	4
					la 	$a0, 	blank    
    					syscall
    				
    				addi	$t0,	$t0,	1
    				j ILp
    		endILp:
    		
    			li 	$v0, 	4
			la 	$a0, 	wall    
    			syscall
    			syscall
    			la 	$a0, 	endl    
    			syscall
    		
    			addi	$t1,	$t1,	-1
    			j	OLp
    	endOLp:
    	
    		li 	$v0, 	4
		la 	$a0, 	wall    
    		syscall
    		syscall
    		la 	$a0, 	smallfloor    
    		syscall
    		la 	$a0, 	wall    
    		syscall
    		syscall
    		la 	$a0, 	endl    
    		syscall
    		la 	$a0, 	wall    
    		syscall
    		syscall
    		la 	$a0, 	blank    
    		syscall
    			
    		li	$t0,	1
    	
    	numloop:	beq	$t0,	8,	endnumloop
    	
    			li 	$v0, 	1
			move 	$a0, 	$t0
    			syscall
    			
    			li 	$v0, 	4
			la 	$a0, 	blank    
    			syscall
    			
    			addi	$t0,	$t0,	1
    			j	numloop
    	endnumloop:
    		
		li 	$v0, 	4
		la 	$a0, 	wall    
    		syscall
    		syscall
    		la 	$a0, 	endl    
    		syscall
    		la 	$a0, 	wall    
    		syscall
    		la 	$a0, 	bigfloor    
    		syscall
    		la 	$a0, 	wall    
    		syscall
    		la 	$a0, 	endl    
    		syscall
    		
    		jr 	$ra
    
CHECKINPUT:	move	$s1,	$a0				#1 for p1char, 2 for p2char
		li	$t6,	3				#faults
	
	INPUT:		la 	$a0, 	endl    
			li	$v0,	4
    			syscall
    			la 	$a0, 	inputsign    
    			syscall
			li 	$v0, 	5
    			syscall
    			addi	$v0,	$v0,	-1					#input is [1,7], now make it [0,6]
    			move	$t2,	$v0						#$t2 is input: column number
    			
    			slti	$t0,	$v0,	7 					#check input	<7
			slti	$t1,	$v0, 	0					#		<0
			nor	$t1,	$t1,	$t1					#		>=0
			and	$t0,	$t0,	$t1					#		[0,6]
			
    			beq	$t0,	0,	OUTOFRANGE				#$t0 is false then INPUT is not in [0,6]
    			j	DONERANGEINPUT
    			
    		OUTOFRANGE:	beq	$t6,	0,	FORCELOSE
    				
    				li 	$v0, 	4
    				la	$a0,	outofrange
    				syscall
    				li 	$v0, 	1
    				move	$a0,	$t6
    				syscall
    				li 	$v0, 	4
    				la	$a0,	warn
    				syscall
    				
    				addi	$t6, 	$t6, 	-1
    				
    				j	INPUT
    	
    	DONERANGEINPUT:	la	$t3,	HEIGHT
    			li	$t0,	0						
    		
    		loopheight:	beq	$t0,	$t2,	endloopheight
    				addi	$t3,	$t3,	4
    				addi	$t0,	$t0,	1
    				j	loopheight
    				
    		endloopheight:
    	
    			lw	$t4,	0($t3)							#$t4=HEIGHT[column]
    			beq	$t4,	6,	FULLCOLUMN
    			j	DONEHEIGHTCHECK
    			
    			FULLCOLUMN:
    				beq	$t6,	0,	FORCELOSE
    				
    				li 	$v0, 	4
    				la	$a0,	maxheight
    				syscall
    				li 	$v0, 	1
    				move	$a0,	$t6
    				syscall
    				li 	$v0, 	4
    				la	$a0,	warn
    				syscall
    				
    				addi	$t6, 	$t6, 	-1
    				
    				j	INPUT
    	
    	DONEHEIGHTCHECK:la	$t5,	BOARD
    			li	$t6,	6
    			mul	$t7,	$t2,	$t6
    			
    			add	$t7,	$t7,	$t4						#to right column
    			add	$t5,	$t5,	$t7						#to right row
    			sb	$s1	0($t5)
    			
    			addi	$t4,	$t4,	1						#HEIGHT[column]++
    			sw	$t4,	0($t3)
    		
    		addi	$t4,	$t4,	-1
    		move	$v1,	$t7 
    		jr	$ra
    		##end
    	FORCELOSE:	beq	$s1,	1,	changeS1to2
    			addi	$s1,	$0,	1
    			j	donechange
    	changeS1to2:	addi	$s1,	$0,	2
    	donechange:	j 	endgame
    	
    		
movep1:		addi	$sp,	$sp,	-4
		sw	$ra,	0($sp)
		
		li 	$v0, 	4
		la 	$a0, 	askline1    
    		syscall
    		la 	$a0, 	name1    
    		syscall
		la 	$a0, 	askline2    
    		syscall
    		la 	$a0, 	p1char
    		syscall
    		la 	$a0, 	askline3  
    		syscall

	undop1:  li	$a0,	1
    		jal	CHECKINPUT
    		li	$a0,	1
    		jal	CHECKWIN
    		beq	$v0,	1,	endgame
    		
    		la	$t0,	undocountp1
    		lw	$t0,	($t0) 
    		beq	$t0,	0,	donep1
    		
    		jal	printboard
    		li 	$v0, 	4
    	 	la 	$a0, 	askundo1    
    		syscall
    		la	$t0,	undocountp1
    		lw	$t0,	($t0) 
    		li 	$v0, 	1
    	 	move 	$a0, 	$t0
    		syscall
    		li 	$v0, 	4
    	 	la 	$a0, 	askundo2   
    		syscall
    		la 	$a0, 	endl    
    		syscall
    		la 	$a0, 	inputsign    
    		syscall
    		
       scanYNp1:li 	$v0, 	8       		#scanf
		la 	$a0, 	INPUTBYTE  	
    		li 	$a1, 	4      
    		syscall
    		
    		la	$t1,	INPUTBYTE
    		lb	$t1,	($t1)
    		beq	$t1,	'N',	donep1
    		beq	$t1,	'Y',	chosenUndop1
    		li 	$v0, 	4
    	 	la 	$a0, 	invalidYN
    	 	syscall
    	 	j	scanYNp1
    		
    	chosenUndop1:	la	$t2,	BOARD			#Undo BOARD
    			add	$t2,	$t2,	$v1
    			sb	$0,	($t2)
    			
    			li	$t6,	6
    			li	$t7,	4
    			
    			div	$v1,	$t6 			#Undo HEIGHT 
    			mfhi	$t3 			#remainder	->	row
    			mflo	$t4			#quotient	->	column
    			la	$t5,	HEIGHT	
    			mul	$t4,	$t4,	$t7
    			add	$t5,	$t5,	$t4
    			
    			sw	$t3,	0($t5)
    			
    			li 	$v0, 	4
    	 		la 	$a0, 	askundoinput
    	 		syscall
    	 		la	$t0,	undocountp1
    			lw	$t0,	($t0) 
    	 		addi	$t0,	$t0,	-1
    	 		sw	$t0,	undocountp1
    	 		
    			j	undop1
    			
	donep1:	lw	$ra,	0($sp)
    		jr	$ra
    
movep2:		addi	$sp,	$sp,	-4
		sw	$ra,	0($sp)

		li 	$v0, 	4
		la 	$a0, 	askline1    
    		syscall
    		la 	$a0, 	name2  
    		syscall
		la 	$a0, 	askline2    
    		syscall
    		la 	$a0, 	p2char
    		syscall
    		la 	$a0, 	askline3  
    		syscall
    	
undop2:    	li	$a0,	2
    		jal	CHECKINPUT
    		li	$a0,	2
    		jal	CHECKWIN
    		beq	$v0,	1,	endgame
    		
    		la	$t0,	undocountp2
    		lw	$t0,	($t0) 
    		beq	$t0,	0,	donep2
    		
    		jal	printboard
    		li 	$v0, 	4
    	 	la 	$a0, 	askundo1    
    		syscall
    		la	$t0,	undocountp2
    		lw	$t0,	($t0) 
    		li 	$v0, 	1
    	 	move 	$a0, 	$t0
    		syscall
    		li 	$v0, 	4
    	 	la 	$a0, 	askundo2   
    		syscall
    		la 	$a0, 	endl    
    		syscall
    		la 	$a0, 	inputsign    
    		syscall
    		
       scanYNp2:li 	$v0, 	8       		#scanf
		la 	$a0, 	INPUTBYTE  	
    		li 	$a1, 	4      
    		syscall
    		
    		la	$t1,	INPUTBYTE
    		lb	$t1,	($t1)
    		beq	$t1,	'N',	donep2
    		beq	$t1,	'Y',	chosenUndop2
    		li 	$v0, 	4
    	 	la 	$a0, 	invalidYN
    	 	syscall
    	 	j	scanYNp2
    		
    	chosenUndop2:	la	$t2,	BOARD			#Undo BOARD
    			add	$t2,	$t2,	$v1
    			sb	$0,	($t2)
    			
    			li	$t6,	6
    			li	$t7,	4
    			
    			div	$v1,	$t6 			#Undo HEIGHT 
    			mfhi	$t3 			#remainder	->	row
    			mflo	$t4			#quotient	->	column
    			la	$t5,	HEIGHT	
    			mul	$t4,	$t4,	$t7
    			add	$t5,	$t5,	$t4
    			
    			sw	$t3,	0($t5)
    			
    			li 	$v0, 	4
    	 		la 	$a0, 	askundoinput
    	 		syscall
    	 		la	$t0,	undocountp2
    			lw	$t0,	($t0) 
    	 		addi	$t0,	$t0,	-1
    	 		sw	$t0,	undocountp2
    	 		
    			j	undop2
    		
	donep2: lw	$ra,	0($sp)
    		jr	$ra
    		
CHECKWIN:	move	$s1,	$a0		#player symbol (1 for p1char, 2 for p2char)
		la	$s6,	BOARD
		li	$t6,	6
		
		li	$t5,	0			
CHECKWINLOOP:	beq	$t5,	42,	ENDCHECKWIN			#check all index if win
		add	$s2,	$s6,	$t5			#$s2 is index of BOARD need to check
		lb	$s4,	0($s2)				#check if BOARD[s2] not equal to player symbol
		bne	$s4,	$s1,	NODIRLEFT
		
	NORTH:		move	$s3,	$t5		#$s3 is index of BOARD need to check
			li	$t0,	0
			
		loopN:	beq	$t0,	3,	WIN	
			addi	$s3,	$s3,	1	#go NORTH on BOARD
			
				div	$s3,	$t6 			#check if go to TOP wall
				mfhi 	$t1				
				beq	$t1,	0,	EAST
			
				add	$s7,	$s6,	$s3
				lb	$s4,	($s7)			#check if BOARD[s3] not equal to player symbol
				bne	$s4,	$s1,	EAST	
					
			addi	$t0,	$t0,	1
			j 	loopN
			
	EAST:		move	$s3,	$t5		#$s3 is index of BOARD need to check
			li	$t0,	0
			
		loopE:	beq	$t0,	3,	WIN	
			addi	$s3,	$s3,	6	#go EAST on BOARD
			
				slti	$t1,	$s3,	42		#check if go to RIGHT wall
				beq	$t1,	0,	NORTHWEST
			
				add	$s7,	$s6,	$s3
				lb	$s4,	($s7)			#check if BOARD[s3] not equal to player symbol		
				bne	$s4,	$s1,	NORTHWEST		
				
			addi	$t0,	$t0,	1
			j 	loopE
			
	NORTHWEST:	move	$s3,	$t5		#$s3 is index of BOARD need to check
			li	$t0,	0
			
		loopNW:	beq	$t0,	3,	WIN	
			addi	$s3,	$s3,	-6	#go NORTHWEST on BOARD
			addi	$s3,	$s3,	1
			
				slti	$t1,	$s3,	0		#check if go to LEFT wall
				beq	$t1,	1,	NORTHEAST
				div	$s3,	$t6			#check if go to TOP wall
				mfhi 	$t2				
				beq	$t2,	0,	NORTHEAST
			
				add	$s7,	$s6,	$s3
				lb	$s4,	($s7)			#check if BOARD[s3] not equal to player symbol		
				bne	$s4,	$s1,	NORTHEAST		
				
			addi	$t0,	$t0,	1
			j 	loopNW
			
	NORTHEAST:	move	$s3,	$t5		#$s3 is index of BOARD need to check
			li	$t0,	0
			
		loopNE:	beq	$t0,	3,	WIN	
			addi	$s3,	$s3,	6	#go NORTHWEST on BOARD
			addi	$s3,	$s3,	1
			
				slti	$t1,	$s3,	42		#check if go to RIGHT wall
				beq	$t1,	0,	NODIRLEFT
				div	$s3,	$t6			#check if go to TOP wall
				mfhi 	$t2				
				beq	$t2,	0,	NODIRLEFT
			
				add	$s7,	$s6,	$s3
				lb	$s4,	($s7)			#check if BOARD[s3] not equal to player symbol			
				bne	$s4,	$s1,	NODIRLEFT		
				
			addi	$t0,	$t0,	1
			j 	loopNE
			
	NODIRLEFT:
		addi	$t5,	$t5,	1
		j	CHECKWINLOOP

	WIN:		li	$v0,	1
			jr	$ra
	ENDCHECKWIN:	li	$v0,	0
			jr	$ra
	
	
	
	
	
	
	
	
	
	
