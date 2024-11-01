.data
input: .word 0
gridsize:   .byte 8,8 
character:  .byte 0,0
num_players: .word 0 
num_boxes: .word 0
seed:   .word 0     
smiley_face: .String "  _____  \n /     \\ \n|  O O  |\n|   ^   |\n|  O    |\n \\_____/\n"
congrats: .String "CONGRATS! YOU SOLVED IT!! HERE'S A SHOCKED FACE!\n"
welcomemessage: .String "Welcome to Sokoban | CONTROLS: \n W: move up \n A: move left \n S: move down \n D: move right \n -1: reset board \n 0: generate new board \n exit: exit the sokoban game"
controls: .String "CONTROLS: \n 1: move up \n 2: move left \n 3: move down \n 4: move right \n 5: pull box up \n 6: pull box left \n 7: pull box down \n 8: pull box right \n -1: reset board \n 0: generate new board \n 100: exit the sokoban game\n\n"
movenotpossible: .String "\nUh Oh! That move isn't possible, try another move! \n"
promptNumPlayers: .String "Enter how many players in the game: \n"
leaderboard_intro: .String "\n\n==== LEADERBOARD ====\n"
promptGridX: .String "Enter the width of the grid: \n"
promptGridY: .String "Enter the height of the grid: \n"
promptNumBoxes: .String "Enter how many boxes in the game: "
prompt_gameinput: .String "\n\nEnter an input: \n"
invalid_input: .String "Invalid Input! Try again: \n"
invalid_grid_width: .String "You need a width of more than 2, try again!"
invalid_grid_height: .String "You need a height of more than 2, try again!"
player_num_prompt: .String "Player Number "
player_num_prompt_continued: .String " is playing\n\n"
leaderboard_prompt: .String " has "
leaderboard_prompt_2: .String " moves!\n"
wall_symbol: .String "#"
empty_space_symbol: .String "."
current_player: .byte 0
char_symbol: .String "O"
box_symbol: .String "B"
target_symbol: .String "X"
newline: .String "\n"
move_up: .word 1
move_left: .word 2
move_down: .word 3
move_right: .word 4
reset_game: .word -1
new_gameboard: .word 0
exit_sokoban: .word 100

#ENHANCEMENTS CHOSEN:

 # 1) Multiplayer Add-On: Labels + Line number that implement this include: 
	 # Line 80 - get_input_numplayers: get from the user, the number of players required
	 # Line 92 - initialise_heap_for_players: setup a dynamic array on the heap that allows storage of player data
	 # Line 198 - PLAYER_LOOPS - for the game to loop the same board until all players have opportunity to play it, while recording scores
	 # Lines 262 and 293 - make_board_backup, and restore_original_board - for the second/third player to play the same board
	 # Line 341 - print_leaderboard: print the leaderboard at the end of each round with cumulative scores of each player ranked
	 # Line 1082 - increment_move_count: increments the moves of the current player when a move is made
	 # Line 1732 - sort_leaderboard: sorts the leaderboard before printing in ascending order to rank players
  
  # 2) Multiple Boxes add-on: Labels + Line number that implement this include: 
  	# Line 142 - SETUP_HEAP - this whole block dynamically stores box and target coordinates and allocates space for the amount of boxes inputted by user
	# Line 143 - get_input_numboxes - the user can choose how many boxes they want on their board configuration
	# Line 1157 - CHECKS - this function checks whether there are any overlapping boxes and targets along with characters
	# Line 1314 - generate_locations_box - this generates randomized locations for the user-defined number of boxes
	# Line 1356 - generate_locations_target - this generates randomized locations for the user-defined number of targets
	# in addition, every memory access and storage has to occur through the heap as box and target locations are dynamically stored, so every function supports this enhancement

#PSEUDORANDOM NUMBER GENERATOR ALGORITHM CHOSEN:
# XORSHIFT PRNG by George Marsaglia:
# Citation: 
# [1]George Marsaglia. 2003. Xorshift RNGs. Journal of Statistical Software 8, 14 (2003). DOI:https://doi.org/10.18637/jss.v008.i14

.text
.globl _start

_start:
GAME:

	#calculation: num boxes decided by user, in the heap, store 2 * num_boxes(same as num_boxes + equal targets) *2(bytes), generate a bunch of boxes, store the values alternatingly in the heap, if the two generated nums are similar to a previous one, redo generation
	#after that space
	#CREATE AN END OF HEAP POINTER
	la s0, character
	la s3, gridsize
	
	la s4, 0x10000000 #heap pointer indicating player information
	#store all boxes together, then store all 
	
	get_input_numplayers:
		la a0, promptNumPlayers
		li a7, 4
		ecall #print prompt for num players
		
		li a7, 5 #take input int value, store in a0
		ecall
		la t0, num_players
		sw a0, 0(t0)
		li t1, 1
		blt a0, t1, get_input_numplayers #keep asking for input until valid (> 0)
		
	initialise_heap_for_players:
		mv t0, s4 #t0 holds the beginning of the heap space for player information store
		lw t1, num_players
		li t2, 0 #COUNTER
		loop_players_setup:
			beq t2, t1, get_input_gridsize
			sb t2, 0(t0)
			sb x0, 1(t0)
			addi t0, t0, 2 #go to the next address
			addi t2, t2, 1
			j loop_players_setup
		
	get_input_gridsize:
		forwidth:
			la a0, promptGridX
			li a7, 4
			ecall #print prompt for num players

			li a7, 5 #take input int value, store in a0
			ecall
			la t0, gridsize
			sb a0, 0(t0)
			
			li t1, 3
			blt a0, t1, retry_width #keep asking for input until valid (> 0)
			j forheight
			retry_width:
				la a0, invalid_grid_width
				li a7, 4
				ecall
				j forwidth
		forheight:
			la a0, promptGridY
			li a7, 4
			ecall #print prompt for num players

			li a7, 5 #take input int value, store in a0
			ecall
			la t0, gridsize
			sb a0, 1(t0)

			li t1, 3
			blt a0, t1, retry_height #keep asking for input until valid (> 0)
			j SETUP_HEAP
			retry_height:
				la a0, invalid_grid_height
				li a7, 4
				ecall
				j forheight
	
	SETUP_HEAP:
			get_input_numboxes: #ASKS FOR NUM_BOXES EVERY ROUND
				la a0, promptNumBoxes
				li a7, 4
				ecall #print prompt for num players

				li a7, 5 #take input int value, store in a0
				ecall
				la t0, num_boxes
				sw a0, 0(t0)
				li t1, 1
				blt a0, t1, get_input_numboxes #keep asking for input until valid (> 0)

			lw t0, num_players
			slli t0, t0, 3 #multiply the number of players by 8 to allocate <numplayers> 8 bytes of space to hold the total moves per player and the player number

			mv t1, s4 #base address of the heap 
			add t1, t1, t0 #add the size of the playermoves array to the base address

			li s10, 0 #setup counter for player loop
			mv s6, t1 #s6 is the pointer in the heap representing the start of an array of all the box positions
			mv t0, s6
			lw t1, num_boxes
			slli t1, t1, 1 #allocate 2 bytes per box (2 bytes for box position)

			add t0, t0, t1 #
			mv s7, t0 # s7 is the pointer for all the targets

			mv t0, s7
			lw t1, num_boxes
			slli t1, t1, 1 #allocate 2 bytes per box (2 bytes for target position)

			add t0, t0, t1 #
			mv s5, t0 #s5 is where we store a copy of the generated board to restore after
			
			
			lw t0, num_boxes
			slli t0, t0, 1
			slli t0, t0, 2#2 bytes per box/target
			addi t0, t0, 2 #last 2 bytes for char
			mv t1, s5
			add t1, t1, t0
			add t1, t1, 2 #2 additional bytes for alignment purposes
			mv s8, t1 # s8 is the pointer for procedures to use the heap
			
		generate_new_board:
				#GENERATE ALL THE LOCATIONS, then check for overlap, then check for solvable
				#PUT EVERYTHING IN A LOOP
				jal generate_locations_char 
				jal generate_locations_box #generate n locations based on number of boxes
				jal generate_locations_target #generate n locations based on number of boxes
				validity_loop:
					jal CHECKS
					
		jal make_board_backup
		
	PLAYER_LOOPS:
			lw t0, num_players
			beq s10, t0, end_current_round 
			
			
			jal restore_original_board
			
			jal clear_console #spam newlines for clear screen
			
			#player identification
			la a0, player_num_prompt
			li a7, 4
			ecall
			mv a0, s10
			li a7, 1
			ecall
			la a0, player_num_prompt_continued
			li a7, 4
			ecall
			
			j game_loop
			#jump to game_loop, game loop repeats fully till ended. and is called again for the same game for the next player

			game_loop:
				
				jal check_game_solved
				li t0, 1
				beq a0, t0, solved_the_round
				#ask for user input W, A, S, D, -1, 0, or e
				
				la a0, controls
				li a7, 4
				ecall
				
				jal PRINT_BOARD
				
				la a0, prompt_gameinput
				li a7, 4
				ecall
				
				li a7, 5                             # Syscall for read string
				ecall                                 # Read user input
				
				la t0, input
				sw a0, 0(t0) #store input value in "input"
				
				jal change_char_position 
				# 1 -> move up
				# 2 -> move left
				# 3 -> move down
				# 4 -> move right
				# -1 -> reset board
				# 0 -> generate new board
				# 100 -> exit game
				
				j game_loop
		
	end_current_round:
		li s10, 0 #reset the player index counter for player loops
		jal print_leaderboard
		j generate_new_board
		#end the round by printing the leaderboard, then asking the user to type Sokoban for a new game
	
	
	make_board_backup:
			#STORE ORIGINAL COORDINATES FROM S5
			mv t0, s5
			#STORE INITIAL CHARACTER POSITION
			lb t2, 0(s0)
			sb t2, 0(t0)
			lb t2, 1(s0)
			sb t2, 1(t0)
			
			addi t0, t0, 2 #go past the character values
			
			#STORE BOX AND TARGET POSITIONS
			lw t1, num_boxes
			slli t1, t1, 1 #multiply num_boxes by 2 to get numboxes+numtargets
			add t2, x0, x0 #counter
			mv t3, s6 #start of storage for boxes and targets
			loop_store_backup:
				beq t2, t1, end_backup
				lb t4, 0(t3)
				lb t5, 1(t3)
				sb t4, 0(t0) #storing in backup
				sb t5, 1(t0) #storing in backup
				
				addi t0, t0, 2
				addi t3, t3, 2
				addi t2, t2, 1
				j loop_store_backup
			
			end_backup:
				ret
		
	restore_original_board:
		#STORE ORIGINAL COORDINATES FROM S5
			mv t0, s5
			#RESTORE INITIAL CHARACTER POSITION
			lb t2, 0(t0)
			sb t2, 0(s0)
			lb t2, 1(t0)
			sb t2, 1(s0)
			
			addi t0, t0, 2 #go past the character values
			
			#STORE BOX AND TARGET POSITIONS
			lw t1, num_boxes
			slli t1, t1, 1 #multiply num_boxes by 2 to get numboxes+numtargets
			add t2, x0, x0 #counter
			mv t3, s6 #start of storage for boxes and targets
			loop_restore_backup:
				beq t2, t1, end_restoration
				lb t4, 0(t0)
				lb t5, 1(t0)
				sb t4, 0(t3) #storing in backup
				sb t5, 1(t3) #storing in backup
				
				addi t0, t0, 2
				addi t3, t3, 2
				addi t2, t2, 1
				j loop_restore_backup
			
			end_restoration:
				ret
		
	solved_the_round:
		#PRINT A CONGRATS
		la a0, congrats
		li a7, 4
		ecall
		la a0, newline
		li a7, 4
		ecall
		la a0, smiley_face
		li a7, 4
		ecall
		la a0, newline
		li a7, 4
		ecall
		addi s10, s10, 1 #increment the player index counter
		j PLAYER_LOOPS

print_leaderboard:

	la a0, leaderboard_intro
	li a7, 4
	ecall
	
	addi sp, sp, -4
	sw ra, 0(sp)
	jal sort_leaderboard #first sort the leaderboard
	
	mv t0, s4 #load the location of player data
	add t1, x0, x0 #counter
	lw t2, num_players
	loop_leaderboard:
		beq t1, t2, exit_loop_leaderboard
		
		la a0, player_num_prompt
		li a7, 4
		ecall
		
		lb a0, 0(t0)
		li a7, 1
		ecall
		
		la a0, leaderboard_prompt
		li a7, 4
		ecall
		
		lb a0, 1(t0)
		li a7, 1
		ecall
		
		la a0, leaderboard_prompt_2
		li a7, 4
		ecall
		
		addi t0, t0, 2
		addi t1, t1, 1
		
		j loop_leaderboard
		
	exit_loop_leaderboard:
		la a0, newline
		li a7, 4
		ecall
		ecall
		
		lw ra, 0(sp)
		addi sp, sp, 4
		ret
		
check_game_solved:
	mv t0, s6 #base address for boxes
	mv t1, s7 #base address for targets
	li t2, 0 #outer loop counter
	li t3, 0 #inner loop counter
	
	loop_match_boxtarget:
		lw t4, num_boxes
		beq t2, t4, game_solved
		
		inner_loop_targets:
			lw t4, num_boxes
			beq t3, t4, game_not_solved
			
			lb t4, 0(t0)
			lb t5, 0(t1)
			beq t4, t5, check_y_boxandtarget
			j skip_checking
			check_y_boxandtarget:
				lb t4, 1(t0)
				lb t5, 1(t1)
				beq t4, t5, check_next_box
				
		skip_checking:
			addi t1, t1, 2
			addi t3, t3, 1
			j inner_loop_targets
			
		check_next_box:
			addi t0, t0, 2
			mv t1, s7
			addi t2, t2, 1
			add t3, x0, x0
			j loop_match_boxtarget
			
	game_not_solved:
		li a0, -1
		ret
	game_solved:
		li a0, 1
		ret
		
move_box_up:
	mv t0, a0
	slli t0, t0, 1 #multiply by two to get the exact position of the box
	mv t1, s6
	add t1, t1, t0
	lb t2, 1(t1)
	addi t2, t2, -1
	sb t2, 1(t1)
	ret
	
move_box_down:
	mv t0, a0
	slli t0, t0, 1 #multiply by two to get the exact position of the box
	mv t1, s6
	add t1, t1, t0
	lb t2, 1(t1)
	addi t2, t2, 1
	sb t2, 1(t1)
	ret
	
move_box_right:
	mv t0, a0
	slli t0, t0, 1 #multiply by two to get the exact position of the box
	mv t1, s6
	add t1, t1, t0
	lb t2, 0(t1)
	addi t2, t2, 1
	sb t2, 0(t1)
	ret
move_box_left:
	mv t0, a0
	slli t0, t0, 1 #multiply by two to get the exact position of the box
	mv t1, s6
	add t1, t1, t0
	lb t2, 0(t1)
	addi t2, t2, -1
	sb t2, 0(t1)
	ret
	
change_char_position:
	#PUSH RA ON THE STACK
	addi sp, sp, -4
	sw ra, 0(sp)
	
	#put in a0 the parameter, user input	
	lb t1, 0(s0) #char x coord
	lb t2, 1(s0) #char y coord
	addi sp, sp, -4 
	sb t1, 2(sp)
	sb t2, 3(sp)
	
	compare_check:
		lw t0, input                # Load word from user input into t0

		li t1, 1     
		beq t0, t1, move_upwards      
		
		li t1, 3
		beq t0, t1, move_downwards     
		
		li t1, 2                 
		beq t0, t1, move_leftwards       

		li t1, 4
		beq t0, t1, move_rightwards      
		
		li t1, 5
		beq t0, t1, pull_upwards
		
		li t1, 6
		beq t0, t1, pull_leftwards
		
		li t1, 7
		beq t0, t1, pull_downwards
		
		li t1, 8
		beq t0, t1, pull_rightwards
		
		li t1, -1
		beq t0, t1, reset_gameboard
		
		li t1, 0
		beq t0, t1, GAME
		
		li t1, 100
		beq t0, t1, EXIT_SOKOBAN
		
		#if input matches none, then user has to re-enter
		la a0, invalid_input
		li a7, 4
		ecall
		
		addi sp, sp, 4
		j game_loop
		
	
	move_upwards:
		lb a0, 2(sp)
		lb a1, 3(sp)
		addi a1, a1, -1
		sb a1, 3(sp)
		
		jal valid_coordinate
		li t3, -1
		beq a0, t3, invalid_move
		
		#now check if the player is on a box's position
		add t1, x0, x0 #counter to check n boxes
		lw t2, num_boxes #load the num_boxes to compare t
		lb t5, 2(sp)
		lb t6, 3(sp)
		#addi t6, t6, -1 NOT NEEDED
		mv t0, s6 #location for boxes
		
		loop_through_boxes:
			beq t1, t2, end_check_boxup
			
			lb t3, 0(t0) #box t0's xth position
			lb t4, 1(t0) #box t0's yth position
			beq t3, t5, continue_equality
			j skip_check
			continue_equality:
				beq t4, t6, found_equal_up
			skip_check:
				addi t0, t0, 2
				addi t1, t1, 1
				j loop_through_boxes
			
			found_equal_up:
				lb a0, 2(sp)
				lb a1, 3(sp) #wanna save this value
				addi sp, sp, 4

				#store which box (nth) was equal to char position on stack
				mv t6, t1 #keep this saved 
			
				addi a1, a1, -1 # check if the position above the changed position is valid
				jal valid_coordinate_for_box
				li t3, -1
				beq a0, t3, invalid_move
				
				#else the box can be moved
				lb t1, 1(s0) #move the character 
				addi t1, t1, -1
				sb t1, 1(s0)
				
				#INCREMENT THE MOVES COUNT FOR CURRENT PLAYER STORED IN S10
				mv a0, s10 #move the current player number into a0, parameter
				jal increment_move_count
				
				#lw t1, 0(sp) WHAT IS THIS FOR
				# addi sp, sp, 4 WHAT IS THIS FOR
				mv a0, t6 #put which box number it was into this, so that it can update position
				
				jal move_box_up #move the box up, check if game solved, or update the screen
				lw ra, 0(sp)
				addi sp, sp, 4
				ret
				
		#first check if the coordinate is valid, then check if this move causes box to move
		#in the box move check if the box goes over target
		end_check_boxup: #box was not moved - just move char and print new board, increment player moves
			#INCREMENT THE MOVES COUNT FOR CURRENT PLAYER STORED IN S10
			lb t0, 2(sp)
			lb t1, 3(sp)
			sb t0, 0(s0)
			sb t1, 1(s0)
			
			addi sp, sp, 4
			
			jal increment_move_count
			
			lw ra, 0(sp)
			addi sp, sp, 4
			
			ret
			
	move_downwards:
		lb a0, 2(sp)
		lb a1, 3(sp)
		addi a1, a1, 1
		sb a0, 2(sp)
		sb a1, 3(sp)
		
		jal valid_coordinate
		li t3, -1
		beq a0, t3, invalid_move
		
		#now check if the player is on a box's position
		add t1, x0, x0 #counter to check n boxes
		lw t2, num_boxes #load the num_boxes to compare to
		lb t5, 2(sp)
		lb t6, 3(sp)
		mv t0, s6 #location for boxes
		
		loop_through_boxes_down:
			beq t1, t2, end_check_boxdown
			
			lb t3, 0(t0) #box t0's xth position
			lb t4, 1(t0) #box t0's yth position
			beq t3, t5, continue_equality_down
			j skip_check_down
			continue_equality_down:
				beq t4, t6, found_equal_down
			skip_check_down:
				addi t0, t0, 2
				addi t1, t1, 1
				j loop_through_boxes_down
			
			found_equal_down:
				lb a0, 2(sp)
				lb a1, 3(sp) #wanna save this value
				addi sp, sp, 4
			
				#store which box (nth) was equal to char position on stack
				mv t6, t1 #keep this saved 
				
				addi a1, a1, 1 # check if the position above the changed position is valid
				jal valid_coordinate_for_box
				li t3, -1
				beq a0, t3, invalid_move
				
				#else the box can be moved
				lb t1, 1(s0) #move the character 
				addi t1, t1, 1
				sb t1, 1(s0) 
				
				jal increment_move_count
				
				mv a0, t6 #put which box number it was into this, so that it can update position
				
				jal move_box_down #move the box up, check if game solved, or update the screen
				
				lw ra, 0(sp)
				addi sp, sp, 4
				ret
				
		#first check if the coordinate is valid, then check if this move causes box to move
		#in the box move check if the box goes over target
		end_check_boxdown: #box was not moved - just move char and print new board, increment player moves
			lb t0, 2(sp)
			lb t1, 3(sp)
			sb t0, 0(s0)
			sb t1, 1(s0)
			
			addi sp, sp, 4
			
			jal increment_move_count
			
			lw ra, 0(sp)
			addi sp, sp, 4
			
			ret
		
	move_leftwards:
		lb a0, 2(sp)
		lb a1, 3(sp)
		addi a0, a0, -1
		sb a0, 2(sp)
		sb a1, 3(sp)
		
		jal valid_coordinate
		li t3, -1
		beq a0, t3, invalid_move
		
		#now check if the player is on a box's position
		add t1, x0, x0 #counter to check n boxes
		lw t2, num_boxes #load the num_boxes to compare to
		lb t5, 2(sp)
		lb t6, 3(sp)
		mv t0, s6 #location for boxes
		
		loop_through_boxes_left:
			beq t1, t2, end_check_boxleft
			
			lb t3, 0(t0) #box t0's xth position
			lb t4, 1(t0) #box t0's yth position
			beq t3, t5, continue_equality_left
			j skip_check_left
			continue_equality_left:
				beq t4, t6, found_equal_left
			skip_check_left:
				addi t0, t0, 2
				addi t1, t1, 1
				j loop_through_boxes_left
			
			found_equal_left:
				lb a0, 2(sp)
				lb a1, 3(sp) #wanna save this value
				addi sp, sp, 4
			
				#store which box (nth) was equal to char position on stack
				mv t6, t1 #keep this saved 
				
				addi a0, a0, -1 # check if the position above the changed position is valid
				jal valid_coordinate_for_box
				li t3, -1
				beq a0, t3, invalid_move
				
				#else the box can be moved
				lb t1, 0(s0) #move the character 
				addi t1, t1, -1
				sb t1, 0(s0) 
				
				jal increment_move_count
				
				mv a0, t6 #put which box number it was into this, so that it can update position
				
				jal move_box_left #move the box up, check if game solved, or update the screen
				
				lw ra, 0(sp)
				addi sp, sp, 4
				ret
				
		#first check if the coordinate is valid, then check if this move causes box to move
		#in the box move check if the box goes over target
		end_check_boxleft: #box was not moved - just move char and print new board, increment player moves
			lb t0, 2(sp)
			lb t1, 3(sp)
			sb t0, 0(s0)
			sb t1, 1(s0)
			
			addi sp, sp, 4
			
			jal increment_move_count
			
			lw ra, 0(sp)
			addi sp, sp, 4
			
			ret
			
	move_rightwards:
		lb a0, 2(sp)
		lb a1, 3(sp)
		addi a0, a0, 1
		sb a0, 2(sp)
		sb a1, 3(sp)
		
		jal valid_coordinate
		li t3, -1
		beq a0, t3, invalid_move
		
		#now check if the player is on a box's position
		add t1, x0, x0 #counter to check n boxes
		lw t2, num_boxes #load the num_boxes to compare to
		lb t5, 2(sp)
		lb t6, 3(sp)
		mv t0, s6 #location for boxes
		
		loop_through_boxes_right:
			beq t1, t2, end_check_boxright
			
			lb t3, 0(t0) #box t0's xth position
			lb t4, 1(t0) #box t0's yth position
			beq t3, t5, continue_equality_right
			j skip_check_right
			continue_equality_right:
				beq t4, t6, found_equal_right
			skip_check_right:
				addi t0, t0, 2
				addi t1, t1, 1
				j loop_through_boxes_right
			
			found_equal_right:
				lb a0, 2(sp)
				lb a1, 3(sp) #wanna save this value
				addi sp, sp, 4
			
				#store which box (nth) was equal to char position on stack
				mv t6, t1 #keep this saved 
				
				addi a0, a0, 1 # check if the position above the changed position is valid
				jal valid_coordinate_for_box
				li t3, -1
				beq a0, t3, invalid_move
				
				#else the box can be moved
				lb t1, 0(s0) #move the character 
				addi t1, t1, 1
				sb t1, 0(s0) 
				
				jal increment_move_count

				mv a0, t6 #put which box number it was into this, so that it can update position
				
				jal move_box_right #move the box up, check if game solved, or update the screen
				
				lw ra, 0(sp)
				addi sp, sp, 4
				ret
				
		#first check if the coordinate is valid, then check if this move causes box to move
		#in the box move check if the box goes over target
		end_check_boxright: #box was not moved - just move char and print new board, increment player moves
			lb t0, 2(sp)
			lb t1, 3(sp)
			sb t0, 0(s0)
			sb t1, 1(s0)
			
			addi sp, sp, 4
			
			jal increment_move_count
			
			lw ra, 0(sp)
			addi sp, sp, 4
			
			ret
		
	pull_upwards:
		lb a0, 2(sp)
		lb a1, 3(sp)
		addi a1, a1, -1
		sb a0, 2(sp)
		sb a1, 3(sp)

		jal valid_coordinate_for_box
		li t3, -1
		beq a0, t3, invalid_move
		
		#now check if the player is above a box's position
		add t1, x0, x0 #counter to check n boxes
		lw t2, num_boxes #load the num_boxes to compare to
		lb t5, 2(sp)
		lb t6, 3(sp)
		addi t6, t6, 1
		mv t0, s6 #location for boxes
		
		loop_through_boxes_above:
			beq t1, t2, invalid_move
			
			lb t3, 0(t0) #box t0's xth position
			lb t4, 1(t0) #box t0's yth position
			addi t4, t4, -1 #to compare whether the spot above the box is where the player is
			beq t3, t5, continue_equality_above
			j skip_check_above
			continue_equality_above:
				beq t4, t6, found_equal_above
			skip_check_above:
				addi t0, t0, 2
				addi t1, t1, 1
				j loop_through_boxes_above
			
			found_equal_above:
				lb a0, 2(sp)
				lb a1, 3(sp) #wanna save this value
				addi sp, sp, 4
			
				#store which box (nth) was equal to char position on stack
				mv t6, t1 #keep this saved 
				
				#else the box can be moved
				lb t1, 1(s0) #move the character 
				addi t1, t1, -1
				sb t1, 1(s0) 
				
				jal increment_move_count
				
				mv a0, t6 #put which box number it was into this, so that it can update position
				
				jal move_box_up #move the box up, check if game solved, or update the screen
				
				lw ra, 0(sp)
				addi sp, sp, 4
				ret				
				
	pull_downwards:
		lb a0, 2(sp)
		lb a1, 3(sp)
		addi a1, a1, 1
		sb a0, 2(sp)
		sb a1, 3(sp)
		
		jal valid_coordinate_for_box
		li t3, -1
		beq a0, t3, invalid_move
		
		#now check if the player is above a box's position
		add t1, x0, x0 #counter to check n boxes
		lw t2, num_boxes #load the num_boxes to compare to
		lb t5, 2(sp)
		lb t6, 3(sp)
		addi t6, t6, -1
		mv t0, s6 #location for boxes
		
		loop_through_boxes_below:
			beq t1, t2, invalid_move
			
			lb t3, 0(t0) #box t0's xth position
			lb t4, 1(t0) #box t0's yth position
			addi t4, t4, 1 #to compare whether the spot below the box is where the player is
			beq t3, t5, continue_equality_below
			j skip_check_below
			continue_equality_below:
				beq t4, t6, found_equal_below
			skip_check_below:
				addi t0, t0, 2
				addi t1, t1, 1
				j loop_through_boxes_below
			
			found_equal_below:
				lb a0, 2(sp)
				lb a1, 3(sp) #wanna save this value
				addi sp, sp, 4
			
				#store which box (nth) was equal to char position on stack
				mv t6, t1 #keep this saved 
				
				#else the box can be moved
				lb t1, 1(s0) #move the character 
				addi t1, t1, 1
				sb t1, 1(s0) 
				
				jal increment_move_count
				
				mv a0, t6 #put which box number it was into this, so that it can update position
				
				jal move_box_down #move the box up, check if game solved, or update the screen
				
				lw ra, 0(sp)
				addi sp, sp, 4
				ret	
				
	pull_leftwards:
		lb a0, 2(sp)
		lb a1, 3(sp)
		addi a0, a0, -1
		sb a0, 2(sp)
		sb a1, 3(sp)
		
		jal valid_coordinate_for_box
		li t3, -1
		beq a0, t3, invalid_move
		
		#now check if the player is above a box's position
		add t1, x0, x0 #counter to check n boxes
		lw t2, num_boxes #load the num_boxes to compare to
		lb t5, 2(sp)
		lb t6, 3(sp)
		addi t5, t5, 1
		mv t0, s6 #location for boxes
		
		loop_through_boxes_toleft:
			beq t1, t2, invalid_move
			
			lb t3, 0(t0) #box t0's xth position
			lb t4, 1(t0) #box t0's yth position
			addi t3, t3, -1 #to compare whether the spot to the left of the box is where the player is
			beq t3, t5, continue_equality_toleft
			j skip_check_toleft
			continue_equality_toleft:
				beq t4, t6, found_equal_toleft
			skip_check_toleft:
				addi t0, t0, 2
				addi t1, t1, 1
				j loop_through_boxes_toleft
			
			found_equal_toleft:
				lb a0, 2(sp)
				lb a1, 3(sp) #wanna save this value
				addi sp, sp, 4
			
				#store which box (nth) was equal to char position on stack
				mv t6, t1 #keep this saved 
				
				#else the box can be moved
				lb t1, 0(s0) #move the character 
				addi t1, t1, -1
				sb t1, 0(s0) 
				
				jal increment_move_count
				
				mv a0, t6 #put which box number it was into this, so that it can update position
				
				jal move_box_left #move the box up, check if game solved, or update the screen
				
				lw ra, 0(sp)
				addi sp, sp, 4
				ret	
		
	pull_rightwards:
		lb a0, 2(sp)
		lb a1, 3(sp)
		addi a0, a0, 1
		sb a0, 2(sp)
		sb a1, 3(sp)
		
		jal valid_coordinate_for_box
		li t3, -1
		beq a0, t3, invalid_move
		
		#now check if the player is above a box's position
		add t1, x0, x0 #counter to check n boxes
		lw t2, num_boxes #load the num_boxes to compare to
		lb t5, 2(sp)
		lb t6, 3(sp)
		addi t5, t5, -1
		mv t0, s6 #location for boxes
		
		loop_through_boxes_toright:
			beq t1, t2, invalid_move
			
			lb t3, 0(t0) #box t0's xth position
			lb t4, 1(t0) #box t0's yth position
			addi t3, t3, 1 #to compare whether the spot to the right of the box is where the player is
			beq t3, t5, continue_equality_toright
			j skip_check_toright
			continue_equality_toright:
				beq t4, t6, found_equal_toright
			skip_check_toright:
				addi t0, t0, 2
				addi t1, t1, 1
				j loop_through_boxes_toleft
			
			found_equal_toright:
				lb a0, 2(sp)
				lb a1, 3(sp) #wanna save this value
				addi sp, sp, 4
			
				#store which box (nth) was equal to char position on stack
				mv t6, t1 #keep this saved 
				
				#else the box can be moved
				lb t1, 0(s0) #move the character 
				addi t1, t1, 1
				sb t1, 0(s0) 
				
				jal increment_move_count
				
				mv a0, t6 #put which box number it was into this, so that it can update position
				
				jal move_box_right #move the box up, check if game solved, or update the screen
				
				lw ra, 0(sp)
				addi sp, sp, 4
				ret	
				
		
reset_gameboard:
	lw ra, 0(sp)
	addi sp, sp, 4
	j PLAYER_LOOPS
		
invalid_move:
	la a0, movenotpossible
	li a7, 4
	ecall 
	j game_loop #ask for input all over again if invalid
		
increment_move_count:
	mv t0, s10 #get the current player
	mv t1, s4
	slli t0, t0, 1
	add t1, t1, t0
	lb t0, 1(t1)
	addi t0, t0, 1
	sb t0, 1(t1)
	ret
		
	
valid_coordinate_for_box: #its only valid for a box if the coordinate there is not another box's position
	addi sp, sp, -4
	sw ra, 0(sp)
	
	add t1, x0, x0 #counter to check n boxes
	lw t2, num_boxes #load the num_boxes to compare t
	mv t0, s6
	
	loop_boxes:
		beq t1, t2, end_check_equality
			
		lb t3, 0(t0)
		lb t4, 1(t0)
		beq t3, a0, cont_equality
		j skipcheck
		
		cont_equality:
			beq t4, a1, invalid_move_box
		
		skipcheck:
			addi t0, t0, 2
			addi t1, t1, 1
			j loop_boxes
			
	invalid_move_box:
		li a0, -1
		lw ra, 0(sp)
		addi sp, sp, 4
		ret
			
	end_check_equality:
		jal valid_coordinate
		li t0, -1
		beq t0, a0, invalid_move_box
		#move for box is valid
		li a0, 1
		lw ra, 0(sp)
		addi sp, sp, 4
		ret


valid_coordinate:
	lb t0, 0(s3)
	lb t1, 1(s3)
	
	blt a0, t0, x_is_greater_than_zero #num columns should be less than x-gridsize
	j not_valid_coord #this means that the col value isn't less than the x-gridsize
	x_is_greater_than_zero:
		blt a0, x0, not_valid_coord
	is_valid_y_coord:
		blt a1, t1, y_is_greater_than_zero #num rows should be less than y-gridsize
		j not_valid_coord
	y_is_greater_than_zero:
		bge a1, x0, valid_return
		j not_valid_coord
	not_valid_coord:
		li a0, -1 #-1 indicates invalid move
		ret
	valid_return:
		li a0, 1 #1 indicates valid move
		ret
	#load the x/y coordinate in a0 and a1, then return an indicator if its true or false in a0


CHECKS:
	addi sp, sp, -4
	sw x1, 0(sp)
	
	jal check_character_box_overlap
	li t0, -1
	beq a0, t0, generate_new_board
	
	jal check_box_target_overlap
	li t0, -1
	beq a0, t0, generate_new_board
	
	jal check_character_target_overlap
	li t0, -1
	beq a0, t0, generate_new_board
	
	lw x1, 0(sp)
	addi sp, sp, 4
	ret 
	
	# Check if character overlaps with box
	check_character_box_overlap:
		mv t4, s6 #address for value
		li t5, 0 #loop counter
		lw t6, num_boxes
		
		char_box_loop:
			beq t5, t6, no_overlap_character_box
			lb t0, 0(s0) # Load character x-coordinate
			lb t1, 1(s0) # Load character y-coordinate
			lb t2, 0(t4) # Load box x-coordinate
			lb t3, 1(t4) # Load box y-coordinate


			# Check if x-coordinates are equal
			beq t0, t2, check_y_box   # If x0 == x2, check y-coordinates

			j continue_box_char_loop # Jump if x-coordinates are not equal

			check_y_box:
				# Check if y-coordinates are equal
				beq t1, t3, overlap_found_charbox   # If y0 == y2, overlap is found

				j continue_box_char_loop # there is no overlap if the above isn't equal

			continue_box_char_loop:
				addi t4, t4, 2
				addi t5, t5, 1
				j char_box_loop

			overlap_found_charbox:
				# Handle overlap case (e.g., set a flag or print a message)
				li a0, -1
				ret

			no_overlap_character_box:
				# No overlap found
				li a0, 0
				ret

	# Check if box overlaps with target
	check_box_target_overlap:
		li t5, 0 #inner loop counter
		li t6, 0 #outer loop counter
		
		loop_1:
			lw t0, num_boxes
			slli t0, t0, 1
			beq t6, t0, no_overlap_box_target
			
		box_target_loop: #check for box-box or box-target overlap
			beq t5, t6, continue_box_target_loop #skip the box/target being checked currently
			lw t0, num_boxes
			slli t0, t0, 1
			beq t5, t0, next_outer_loop
			
			mv t0, t6
			slli t0, t0, 1
			add t0, t0, s6
			lb t1, 0(t0) # Load first comparison x-coordinate
			lb t2, 1(t0) # Load first comparison y-coordinate
			
			mv t0, t5
			slli t0, t0, 1
			add t0, t0, s6
			lb t3, 0(t0) # Load second comparison x-coordinate
			lb t4, 1(t0) # Load second comparison y-coordinate


			# Check if x-coordinates are equal
			beq t1, t3, check_y_boxtarget   # If x0 == x2, check y-coordinates

			j continue_box_target_loop # Jump if x-coordinates are not equal

			check_y_boxtarget:
				# Check if y-coordinates are equal
				beq t2, t4, overlap_found_boxtarget   # If y0 == y2, overlap is found

				j continue_box_target_loop # there is no overlap if the above isn't equal

			continue_box_target_loop:
				addi t5, t5, 1
				j box_target_loop
				
			next_outer_loop:
				li t5, 0
				addi t6, t6, 1
				j loop_1
			
		overlap_found_boxtarget:
			li a0, -1
			ret

		no_overlap_box_target:
			# No overlap found
			li a0, 0
			ret

	# Check if box overlaps with target
	check_character_target_overlap:
		mv t4, s7 #address for TARGETS
		li t5, 0 #loop counter
		lw t6, num_boxes
		
		char_target_loop:
		beq t5, t6, no_overlap_character_target
		lb t0, 0(s0) # Load character x-coordinate
		lb t1, 1(s0) # Load character y-coordinate
		lb t2, 0(t4) # Load target x-coordinate
		lb t3, 1(t4) # Load target y-coordinate
		
	
		# Check if x-coordinates are equal
		beq t0, t2, check_y_target   # If x0 == x2, check y-coordinates

		j continue_target_char_loop # Jump if x-coordinates are not equal

		check_y_target:
			# Check if y-coordinates are equal
			beq t1, t3, overlap_found_chartarget  # If y0 == y2, overlap is found
			
			j continue_target_char_loop # there is no overlap if the above isn't equal
		
		continue_target_char_loop:
			addi t4, t4, 2
			addi t5, t5, 1
			j char_target_loop
			
		overlap_found_chartarget:
			li a0, -1
			ret

		no_overlap_character_target:
			li a0, 0
			ret


	generate_locations_box:
		addi sp, sp, -8
		sw ra, 4(sp)
		# Randomly position the box
		li t0, 0
		sw t0, 0(sp) #t0 is the counter
		
		loop_box_init:
			lw t0, 0(sp)
			lw t1, num_boxes
			beq t0, t1, end_box_init

			la t0, gridsize
			lb a0, 0(t0)
			jal notrand
			
			mv t0, s6
			lw t1, 0(sp)
			slli t1, t1, 1
			add t0, t0, t1
			sb a0, 0(t0)  # Save the random x coordinate

			la t0, gridsize
			lb a0, 1(t0)
			jal notrand

			mv t0, s6
			lw t1, 0(sp)
			slli t1, t1, 1
			add t0, t0, t1
			sb a0, 1(t0)  # Save the random y coordinate

			lw t0, 0(sp)
			addi t0, t0, 1
			sw t0, 0(sp)
			j loop_box_init

		end_box_init:
			lw x1, 4(sp)
			addi sp, sp, 8
			ret
		
	generate_locations_target:
		addi sp, sp, -8
		sw x1, 4(sp)
		# Randomly position the target
		li t0, 0
		sw t0, 0(sp) #t0 is the counter
		
		loop_target_init:
			lw t0, 0(sp)
			lw t1, num_boxes
			beq t0, t1, end_target_init

			la t0, gridsize
			lb a0, 0(t0)
			jal notrand
			
			mv t0, s7
			lw t1, 0(sp)
			slli t1, t1, 1
			add t0, t0, t1
			sb a0, 0(t0)  # Save the random x coordinate

			la t0, gridsize
			lb a0, 1(t0)
			jal notrand

			mv t0, s7
			lw t1, 0(sp)
			slli t1, t1, 1
			add t0, t0, t1
			sb a0, 1(t0)  # Save the random y coordinate

			lw t0, 0(sp)
			addi t0, t0, 1
			sw t0, 0(sp)
			j loop_target_init

		end_target_init:
			lw x1, 4(sp)
			addi sp, sp, 8
			ret

		
generate_locations_char:
		addi sp, sp, -4
		sw x1, 0(sp)
		
		la t0, gridsize
		lb a0, 0(t0)
		jal notrand
		
		sb a0, 0(s0)  # Save the random x coordinate
		
		add a0, x0, x0
		
		la t0, gridsize
		lb a0, 1(t0)
		jal notrand

		sb a0, 1(s0)  # Save the random y coordinate
		
		lw x1, 0(sp)
		addi sp, sp, 4
		ret
		
PRINT_BOARD: #integrate using the heap here
	#load everything onto a stack then print altogether
	mv s9, sp #store the initial state of sp in s9
	sw x1, 0(s8)#store the main function's ra 
	addi s8, s8, 4 #move the heap pointer forward
	
	add t0, x0, x0 # setting up row counter
	add t1, x0, x0 # setting up column counter
	lb t2, 0(s3) #x width for all walls
	lb t3, 1(s3) #y width for all walls
	
	addi t2, t2, -1 #reducing by 1 for indexing
	addi t3, t3, -1 #reducing by 1 for indexing
	
	jal top_bottom_wall
	jal initiate_print_rows
	la a0, wall_symbol
	li a7, 4
	ecall
	la a0, newline
	li a7, 4
	ecall
	
	jal top_bottom_wall
	
	addi s8, s8, -4 #decrement the heap pointer
	lw ra, 0(s8)  #restore original function's ra
	li s9, 0 #reset s9 value
	ret
	
	
	top_bottom_wall:
		#PRINT TWO WALLS TO START OFF, as our border will be two wider than the gridsize
		la t4, wall_symbol #PRINT FIRST EXTRA WALL (FOR APPEARANCE)
		mv a0, t4
		li a7, 4
		ecall

		la t4, wall_symbol #PRINT SECOND EXTRA WALL (FOR APPEARANCE)
		mv a0, t4
		li a7, 4
		ecall

		print_walls:
			
			la t4, wall_symbol #PRINT WALL
			mv a0, t4
			li a7, 4
			ecall
		
			addi t1, t1, 1
			beq t1, t2, done_wall
			j print_walls
			
		done_wall:
			la t4, wall_symbol #PRINT SECOND WALL
			mv a0, t4
			li a7, 4
			ecall
			add t1, x0, x0 #reset row counter
			ret
			
	initiate_print_rows:
		init_method_ra:
			sw ra, 0(s8) #store the initial return address on the heap
			addi s8, s8, 4 #increment heap pointer
			
		perform_row_print:
			addi sp, sp, -4
			la t4, newline
			sw t4, 0(sp)

			lb t3, 1(s3) #y width for all walls
			addi t3, t3, -1 #reducing by 1 for indexing

			add t1, x0, x0 #reset the column counter to repeat col number of times

			la t4, wall_symbol #PRINT FIRST WALL
			addi sp, sp, -4
			la t4, wall_symbol
			sw t4, 0(sp)

			print_loop_rows:
				addi sp, sp, -4
				la t4, empty_space_symbol
				sw t4, 0(sp)
				mv t4, t2 
				beq t1, t4, continue_last_wall
				jal initiate_row_print
				addi t1, t1, 1
				j print_loop_rows 
	
			continue_last_wall:
				jal initiate_row_print
				add t1, x0, x0
				la t4, wall_symbol #PRINT SECOND WALL
				addi sp, sp, -4
				la t4, wall_symbol
				sw t4, 0(sp)

			continue_check:
				#increment row count
				beq t0, t3, end_PRINT_BOARD
				addi t0, t0, 1
				j perform_row_print

			
		end_PRINT_BOARD:
			lw t6, 0(s4) #store PRINT_BOARD's return address
			lw ra, 4(s4) #load back the initial return address to ra register
			#SP should be returned to initial value
			
			mv t5, s8 #t5 is the counter for the heap
			load_on_heap:
				beq sp, s9, print_from_heap #if the stack pointer has returned to its original value, then all vales have been loaded. Print from heap.
				lw t4, 0(sp)
				sw t4, 0(t5)
				addi sp, sp, 4
				addi t5, t5, 4 #go to next point on the heap
				j load_on_heap
				
			print_from_heap:
				init_print_heap:
					addi t5, t5, -4
					
				loop_heap:
					lw a0, 0(t5)
					li a7, 4
					ecall
					
					mv t0, s8
					addi t0, t0, 4
					beq t5, t0, end_print_heap
					addi t5, t5, -4
					j loop_heap

			end_print_heap:
				addi s8, s8, -4
				lw ra, 0(s8)
				ret
				
			#ret
		
	initiate_row_print:
		addi sp, sp, -8
		sw t2, 0(sp) #load the x-based gridsize
		sw t3, 4(sp) #load the y-based gridsize
		
		lb t2, 0(s0) #character coordinate x
		lb t3, 1(s0) #character coordinate y
		
		check_char_x:
			beq t2, t1, check_char_y
			j to_box # else go to box if x coordinates are not equal
		check_char_y:
			beq t3, t0, print_char
			
		to_box:
			init:
				li t4, 0
				mv t5, s6
			looping_boxes:
				lw t2, num_boxes
				beq t4, t2, to_target
				
				lb t2, 0(t5) #box coordinate x
				lb t3, 1(t5) #box coordinate y

			check_box_x:
				beq t2, t1, check_box_y
				j continue_looping_box
			check_box_y:
				beq t3, t0, print_box
			continue_looping_box:
				addi t4, t4, 1
				addi t5, t5, 2
				j looping_boxes

		to_target:
			init_targetloop:
				li t4, 0
				mv t5, s7
			looping_targets:
				lw t2, num_boxes
				beq t4, t2, else_print
				
				lb t2, 0(t5) #box coordinate x
				lb t3, 1(t5) #box coordinate y

			check_target_x:
				beq t2, t1, check_target_y
				j continue_looping_target
				
			check_target_y:
				beq t3, t0, print_target
				
			continue_looping_target:
				addi t4, t4, 1
				addi t5, t5, 2
				j looping_targets
				
		else_print:
			j print_empty
			
		end_print:
			ret
	
	#add either one of these chars to the stack
	print_empty:
		lb t2, 0(sp) #load the first x-based gridsize
		lb t3, 4(sp) #load the second y-based gridsize 
		addi sp, sp, 8 # deallocate stack space
		
		la t4, empty_space_symbol
		sw t4, 0(sp)
		j end_print
		
	print_box:
		lb t2, 0(sp) #load the first x-based gridsize
		lb t3, 4(sp) #load the second y-based gridsize 
		addi sp, sp, 8 # deallocate stack space
		
		la t4, box_symbol
		sw t4, 0(sp)
		j end_print
		
	print_target:
		lb t2, 0(sp) #load the first x-based gridsize
		lb t3, 4(sp) #load the second y-based gridsize 
		addi sp, sp, 8 # deallocate stack space
		
		la t4, target_symbol
		sw t4, 0(sp)
		j end_print
		
	print_char:
		lb t2, 0(sp) #load the first x-based gridsize
		lb t3, 4(sp) #load the second y-based gridsize 
		addi sp, sp, 8 # deallocate stack space
		
		la t4, char_symbol
		sw t4, 0(sp)
		j end_print
		
	
#---------HELPER FUNCTION NOTRAND---------#
#PSEUDORANDOM NUMBER GENERATOR ALGORITHM CHOSEN: 
# XORSHIFT PRNG by George Marsaglia:
# Citation: 
# [1]George Marsaglia. 2003. Xorshift RNGs. Journal of Statistical Software 8, 14 (2003). DOI:https://doi.org/10.18637/jss.v008.i14

notrand:
	mv t3, a0
				
	li a7, 32
    ecall   
		
    # Get a dynamic time-based seed
    li a7, 30          # System call for time (returns milliseconds)
    ecall            
		
    la t6, seed
    sb a0, 0(t6)       

    # XORSHIFT Algorithm (32-bit XORSHIFT)
    lw t0, seed        # Load the seed from memory
    li t1, 13          # Shift constant a
    sll t2, t0, t1    
    xor t0, t0, t2    

    li t1, 17        
    srl t2, t0, t1  
    xor t0, t0, t2   

    li t1, 5        
    sll t2, t0, t1     
    xor t0, t0, t2   
	
    li t1, 0xFFFFFFFF
    and t0, t0, t1    

    # Use unsigned remainder to get a number between 0 and n-1
    # Upper bound for modulus
    remu t0, t0, t3    # Use unsigned remainder (t0 % n)

    la t6, seed
    sw t0, 0(t6)       
		
	mv a0, t0
	ret

clear_console:
	la a0, newline
	li a7, 4
	ecall
	ecall
	ecall
	ecall
	ecall
	ecall
	ecall
	ecall
	ecall
	ecall
	ecall
	ecall
	ecall
	ecall
	ecall
	ret

sort_leaderboard: #SORTS LEADRBOARD IN PLACE IN ASCENDING ORDER

	sort_heap_desc:
		lw t0, num_players           # t0 = n (number of players)

	outer_loop:
		mv t3, s4
		beq t0, x0, done      # if t0 == 0, sorting is done

		add t1, x0, x0        # t1 = inner loop index
		mv t2, t0       # t2 = t0 (limit of inner loop)
		addi t2, t2, -1       # t2 = t2 - 1

	inner_loop:
		bge t1, t2, end_inner # if t1 >= t2, end inner loop

		# Load heap[t1] (Player t1 ID and Score) and heap[t1 + 1]
		
		lb t4, 1(t3)          # t4 = heap[t1].score
		lb t5, 3(t3)          # t5 = heap[t1 + 1].score

		blt t4, t5, no_swap   # if heap[t1].score < heap[t1 + 1].score, no swap

		# Swap scores
		sb t5, 1(t3)          
		sb t4, 3(t3)         

		# Swap IDs
		lb t4, 0(t3)          
		lb t5, 2(t3)         
		sb t5, 0(t3)          
		sb t4, 2(t3)  
		
	no_swap:
		addi t1, t1, 1        # t1++
		addi t3, t3, 2
		j inner_loop          # repeat inner loop

	end_inner:
		addi t0, t0, -1       # t0-- (reduce outer loop range)
		j outer_loop          # repeat outer loop

	done:
		ret                   # Return when sorting is done



EXIT_SOKOBAN:
	li a7, 10
	ecall