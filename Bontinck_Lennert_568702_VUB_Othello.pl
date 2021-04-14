/*
Single loadable file for the Othello assignment.
The code is tested to work up until a dummy implementation of computer vs player (4), 
	meaning the heuristic part has not been implemented due to time savings to study for other courses.

A seperate README.md file was made to go over queries that can be made to test singular predicates, 
	a copy of the contents of this README.md file is dropped as a comment block bellow this code.

STUDENT INFO:
	- Name: Bontinck Lennert
	- StudentID: 568702
	- Affiliation: VUB - Master Computer Science: AI 
*/

/* Import the required libraries, io and fill are provided and unchanged with the exception of a removed missing export in io */
:- use_module( [library(lists), io, fill] ).

/* ------------------------ START SUPPLEMENTARY PREDICATES ------------------------ */

/* Succeeds when it's single input argument is an integer between 1 and 8. Makes use of build in SWI Prolog between/3 predicate. */
integer_between_1_and_8( Number ) :- between(1, 8, Number) .

/* Succeeds when it's single input argument is an integer between 1 and 6. Makes use of build in SWI Prolog between/3 predicate. */
integer_between_1_and_6( Number ) :- between(1, 6, Number) .

/* Succeeds when it's single input argument is a valid representation of a board.
	A board is represented as a list of lists (8 x 8) with each inner list representing a column and the elements representing the values in those columns.
	Counting starts from 1, thus the top left is (1, 1), the bottom left is (1, 8), the bottom right is (8, 8) and so on. 
	It also checks if the values are valid board values (a piece or empty space), however, it does not check for valid locations of the pieces. */
valid_board_representation( BoardState ) :- length(BoardState, 8),
												valid_board_columns( BoardState ) .

/* Succeeds when it's single input argument (list of lists) are valid representation of board column.
	Recursive and validates column by column.
	See valid_board_representation for representation details. */
valid_board_columns( [] ) .
valid_board_columns( [CurrentColumn | OtherColumns] ) :- length(CurrentColumn, 8),
															valid_board_values( CurrentColumn ),
															valid_board_columns(OtherColumns) .

/* Succeeds when it's single input argument (list) are board values (either a player symbol or the empty symbol)
	Recursive and validates value by value
	See valid_board_representation for representation details. */
valid_board_values( [] ) .
valid_board_values( [CurrentValue | OtherValues] ) :- is_piece( CurrentValue ),
														valid_board_values( OtherValues ) .
valid_board_values( [CurrentValue | OtherValues] ) :- is_empty( CurrentValue ),
														valid_board_values( OtherValues ) .	

/* Succeeds when: 
	- its first argument is a valid column number: integer between 1 and 8:
	- its second argument is a valid row number: integer between 1 and 8:
	- its third argument is a valid representation of a board state: list of lists (8 x 8) with values being either a player symbol or the empty symbol
	- its fourth argument is a valid player piece
	- The square at the given column and row is the symbol of the player piece. */
player_square( ColumnNumber, RowNumber, BoardState, PlayerPiece ) :- integer_between_1_and_8( ColumnNumber ),
																		integer_between_1_and_8( RowNumber ),
																		valid_board_representation( BoardState ),
																		is_piece( PlayerPiece ),
																		square( ColumnNumber, RowNumber, BoardState, SquareState ),
																		squ(_, _, PlayerPiece) = SquareState .



/* ------------------------ END SUPPLEMENTARY PREDICATES ------------------------ */




/* ------------------------ START BOARD REPRESENTATION ------------------------ */

/* Succeeds when it's single input argument is the symbol for the black player, namely the string '*'. Enclosed in single quotes to asure string. */
is_black( InputPiece ) :- InputPiece = '*' .

/* succeeds when it's single input argument is the symbol for the white player, namely the string 'o'. Enclosed in single quotes to asure string. */
is_white( InputPiece ) :- InputPiece = 'o' .

/* Succeeds when it's single input argument is the symbol for the empty square, namely a space. Enclosed in single quotes to asure string. */
is_empty( InputPiece ):- InputPiece = ' ' .

/* Succeeds when it's single input argument is either the black character or the white character. Split into two predicates as per recommendation of not using 'or'. */
is_piece( InputPiece ) :- is_black( InputPiece ) .
is_piece( InputPiece ) :- is_white( InputPiece ) .

/* Succeeds when both its arguments are player representation characters, but they are dierent. Equality check at the end to combat floundering due to negation. */
other_player( PlayerPiece1, PlayerPiece2 ) :- is_piece( PlayerPiece1 ),
												is_piece( PlayerPiece2 ),
												\+ ( PlayerPiece1 = PlayerPiece2 ) .

/* Succeeds when: 
	- its first argument is a valid row number: integer between 1 and 8:
	- its second argument is a valid representation of a board state: list of lists (8 x 8) with values being either a player symbol or the empty symbol
	- its third argument is the representation of the row at the first arguments index.
*/
row( RowNumber, BoardState, RowState ) :- integer_between_1_and_8( RowNumber ),
											valid_board_representation( BoardState ),
											Columns = BoardState,
											% NOTE: hacky way of using _1, _2 ... since simply using variable X would be a list which has brackets in it and I didn't find a way to remove those brackets.
											% NOTE: uses SWIPL build in maplist operator, of which inspiration was found using:
											% StackOverflow: Get every first element from a list of lists
											% https://stackoverflow.com/questions/50393649/get-every-first-element-from-a-list-of-lists
											maplist(nth1(RowNumber), Columns, [_1, _2, _3, _4, _5, _6, _7, _8]), 
											RowState = row( RowNumber, _1, _2, _3, _4, _5, _6, _7, _8 ) .

/* Succeeds when: 
	- its first argument is a valid column number: integer between 1 and 8:
	- its second argument is a valid representation of a board state: list of lists (8 x 8) with values being either a player symbol or the empty symbol
	- its third argument is the representation of the column at the first arguments index. */

column( ColumnNumber, BoardState, ColState ) :- integer_between_1_and_8( ColumnNumber ),
												valid_board_representation( BoardState ),
												Columns = BoardState,
												% NOTE: hacky way of using _1, _2 ... since simply using variable X would be a list which has brackets in it and I didn't find a way to remove those brackets.
												nth1( ColumnNumber, Columns, [_1, _2, _3, _4, _5, _6, _7, _8] ), 
												ColState = col( ColumnNumber, _1, _2, _3, _4, _5, _6, _7, _8 ) .

/* Succeeds when: 
	- its first argument is a valid column number: integer between 1 and 8:
	- its second argument is a valid row number: integer between 1 and 8:
	- its third argument is a valid representation of a board state: list of lists (8 x 8) with values being either a player symbol or the empty symbol
	- its fourth argument is the representation of the square at the given column and row. */
square( ColumnNumber, RowNumber, BoardState, SquareState ) :- integer_between_1_and_8( ColumnNumber ),
																integer_between_1_and_8( RowNumber ),
																%checking if the board is valid would instantiate the "empty board" when calling flipp.
																%     This caused everything to be horribly slow since all fields would be instantiated to *
																%valid_board_representation( BoardState ),
																Columns = BoardState,
																nth1( ColumnNumber, Columns, Column ), 
																nth1( RowNumber, Column, Square ), 
																SquareState = squ( ColumnNumber, RowNumber, Square ) .
																
/* Succeeds when: 
	- its first argument is a valid column number: integer between 1 and 8:
	- its second argument is a valid row number: integer between 1 and 8:
	- its third argument is a valid representation of a board state: list of lists (8 x 8) with values being either a player symbol or the empty symbol
	- The square at the given column and row is the empty symbol. */
empty_square( ColumnNumber, RowNumber, BoardState ) :- square( ColumnNumber, RowNumber, BoardState, SquareState ),
																		is_empty( EmptyPiece ),
																		squ(_, _, EmptyPiece) = SquareState .

/* Succeeds when its argument represents the initial state of the board. */
initial_board( BoardState ) :- is_empty( EmptyPiece ),
								is_black( BlackPiece ),
								is_white( WhitePiece ),
								BoardState = [[EmptyPiece, EmptyPiece, EmptyPiece, EmptyPiece, EmptyPiece, EmptyPiece, EmptyPiece, EmptyPiece],
												[EmptyPiece, EmptyPiece, EmptyPiece, EmptyPiece, EmptyPiece, EmptyPiece, EmptyPiece, EmptyPiece],
												[EmptyPiece, EmptyPiece, EmptyPiece, EmptyPiece, EmptyPiece, EmptyPiece, EmptyPiece, EmptyPiece],
												[EmptyPiece, EmptyPiece, EmptyPiece, WhitePiece, BlackPiece, EmptyPiece, EmptyPiece, EmptyPiece],
												[EmptyPiece, EmptyPiece, EmptyPiece, BlackPiece, WhitePiece, EmptyPiece, EmptyPiece, EmptyPiece],
												[EmptyPiece, EmptyPiece, EmptyPiece, EmptyPiece, EmptyPiece, EmptyPiece, EmptyPiece, EmptyPiece],
												[EmptyPiece, EmptyPiece, EmptyPiece, EmptyPiece, EmptyPiece, EmptyPiece, EmptyPiece, EmptyPiece],
												[EmptyPiece, EmptyPiece, EmptyPiece, EmptyPiece, EmptyPiece, EmptyPiece, EmptyPiece, EmptyPiece]] .

/* Succeeds when its argument unifies with a representation of the board with distinct variables in the places where the pieces would normally go. */
empty_board( BoardState ) :- BoardState = [[_1, _2, _3, _4, _5, _6, _7, _8],
											[_9, _10, _11, _12, _13, _14, _15, _16],
											[_17, _18, _19, _20, _21, _22, _23, _24],
											[_25, _26, _27, _28, _29, _30, _31, _32],
											[_33, _34, _35, _36, _37, _38, _39, _40],
											[_41, _42, _43, _44, _45, _46, _47, _48],
											[_49, _50, _51, _52, _53, _54, _55, _56],
											[_57, _58, _59, _60, _61, _62, _63, _64]] .


/* ------------------------ END BOARD REPRESENTATION ------------------------ */




/* ------------------------ START SPOTTING A WINNER ------------------------ */

/* succeeds when:
	- its first argument is a board representation
	- its second argument represents the amount of black pieces on the board
	- its third argument represents the amount of white pieces on the board */
count_pieces( BoardState, AmountOfBlackPieces, AmountOfWhitePieces ) :- valid_board_representation( BoardState ),
																		Columns = BoardState,
																		is_black( BlackPiece ), 
																		count_pieces_of_player_in_lists( Columns, BlackPiece, AmountOfBlackPieces ),
																		is_white( WhitePiece ), 
																		count_pieces_of_player_in_lists( Columns, WhitePiece, AmountOfWhitePieces ) .

count_pieces_of_player_in_lists( [], _, 0 ) .
% Using aggregate_all by finding it after looking for an aggragotor function following past use of mapping (buildin)
% https://www.swi-prolog.org/pldoc/doc/_SWI_/library/aggregate.pl
count_pieces_of_player_in_lists( [CurrentColumn | OtherColumns], PlayerSymbol, AmountOfPlayerPieces ) :- aggregate_all(count, member(PlayerSymbol, CurrentColumn), AmountOfPiecesToAdd), 
																											count_pieces_of_player_in_lists( OtherColumns, PlayerSymbol, RemainingAmountOfPlayerPieces ), 
																											AmountOfPlayerPieces is AmountOfPiecesToAdd + RemainingAmountOfPlayerPieces .

/* Succeeds when:
	- its first argument is a board representation
	- its second is the player representation (piece) of the winner of the game */																		
and_the_winner_is(BoardState, PlayerPiece) :- valid_board_representation( BoardState ),
												is_black( PlayerPiece ),
												count_pieces( BoardState, AmountOfBlackPieces, AmountOfWhitePieces ),
												AmountOfBlackPieces > AmountOfWhitePieces .	
and_the_winner_is(BoardState, PlayerPiece) :- valid_board_representation( BoardState ),
												is_white( PlayerPiece ),
												count_pieces( BoardState, AmountOfBlackPieces, AmountOfWhitePieces ),
												AmountOfWhitePieces > AmountOfBlackPieces .	


/* ------------------------ END SPOTTING A WINNER ------------------------ */




/* ------------------------ START HUMAN PLAYERS ------------------------ */

/* given play predicate */
play :- welcome,
			initial_board( Board ),
			display_board( Board ),
			is_black( Black ),
			play( Black, Board ) .
	
/* Succeeds when:
	- Its first argument is the column number for a piece to be placed
	- Its second argument is the row number for a piece to be placed
	- Its third argument is the player which can make the move (piece)
	- Its fourth argument is a valid board state
	- Its fifth argument is the column number for a piece of the player that is already on the board and on the other side of the to place piece
	- Its sixth argument is the row number for a piece of the player that is already on the board and on the other side of the to place piece
	- Its seventh argument is the amount of pieces from the oponent the move would enclose

Ideology:
   - A move is valid if:
      	- It has a valid start and end point
			- start: free
			- end: piece of player
	  	- It has a valid boardstate
      	- It has a valid amount of pieces enclosed
	    	- AmountOfPiecesEnclosed should be exactly the difference of steps betweeen both coordinates over only oponents symbols
	*/	
enclosing_piece( ColumnNumberNewPiece, RowNumberNewPiece, PlayerPieceToPlay, BoardState,
					ColumnNumberOldPiece, RowNumberOldPiece, AmountOfPiecesEnclosed ) :-    %check column numbers
																							integer_between_1_and_8(ColumnNumberNewPiece),
																							integer_between_1_and_8(RowNumberNewPiece),
																							integer_between_1_and_8(ColumnNumberOldPiece),
																							integer_between_1_and_8(RowNumberOldPiece),
																							%check viable amount of pieces enclosed
																							integer_between_1_and_6(AmountOfPiecesEnclosed),
																							check_viable_amount_of_pieces_enclose(ColumnNumberNewPiece, RowNumberNewPiece, ColumnNumberOldPiece, RowNumberOldPiece, AmountOfPiecesEnclosed),
																							%check piece
																							is_piece( PlayerPieceToPlay ),
																							%check board
																							valid_board_representation( BoardState ),
																							%check new piece is free
																							empty_square( ColumnNumberNewPiece, RowNumberNewPiece, BoardState ),
																							%check old piece is piece of current player
																							player_square( ColumnNumberOldPiece, RowNumberOldPiece, BoardState, PlayerPieceToPlay ),
																							%move in right direction so we're on oponents piece and can start recusrion
																							move_needed_between_squares(ColumnNumberNewPiece, RowNumberNewPiece, ColumnNumberOldPiece, RowNumberOldPiece, ColumnMovedNewPiece, RowMovedNewPiece),
																							%do recursive check
																							oponent_pieces_between_squares(ColumnMovedNewPiece, RowMovedNewPiece, ColumnNumberOldPiece, RowNumberOldPiece, BoardState, PlayerPieceToPlay, AmountOfPiecesEnclosed) .

% The new piece is on the old piece and we don't have any pieces left, the path was correct.
oponent_pieces_between_squares( ColumnNumberOldPiece, RowNumberOldPiece, 
									ColumnNumberOldPiece, RowNumberOldPiece, _, _, 0 ) . 



% We can still legally move so we do so
oponent_pieces_between_squares( ColumnNumberNewPiece, RowNumberNewPiece, ColumnNumberOldPiece, RowNumberOldPiece, BoardState,
									PlayerPieceToPlay, AmountOfPiecesEnclosed ) :- AmountOfPiecesEnclosed > 0,
																					%check column numbers
																					integer_between_1_and_8(ColumnNumberNewPiece),
																					integer_between_1_and_8(RowNumberNewPiece),
																					integer_between_1_and_8(ColumnNumberOldPiece),
																					integer_between_1_and_8(RowNumberOldPiece),
																					%check piece
																					is_piece( PlayerPieceToPlay ),
																					%check board
																					valid_board_representation( BoardState ),
																					%check new piece is piece of other player
																					other_player( PlayerPieceToPlay, OtherPlayerPiece ),
																					player_square( ColumnNumberNewPiece, RowNumberNewPiece, BoardState, OtherPlayerPiece ),
																					%update amount of pieces
																					NewAmountOfPiecesEnclosed is AmountOfPiecesEnclosed - 1,
																					%move in right direction so we're on oponents piece and recursive further
																					move_needed_between_squares(ColumnNumberNewPiece, RowNumberNewPiece, ColumnNumberOldPiece, RowNumberOldPiece, ColumnMovedNewPiece, RowMovedNewPiece),
																					oponent_pieces_between_squares(ColumnMovedNewPiece, RowMovedNewPiece, ColumnNumberOldPiece, RowNumberOldPiece, BoardState, PlayerPieceToPlay, NewAmountOfPiecesEnclosed) .



/* 	- Moving from new point to old point should be:
        - rows and columns are equal:
			- we're at the destination, don't move!
		- rows are equal and:
	      	- column new > column old: column new -- to find old
		  	- column new < column old: column new ++ to find old
	   	- columns are equal and:
	      	- row new > row old: row new -- to find old
		  	- row new < row old: row new -- to find old
		- nor rows nor columns are equal:
			- row new > row old, column new > column old: row new -- and column new -- to find old
			- row new > row old, column new < column old: row new -- and column new ++ to find old
			- row new < row old, column new > column old: row new ++ and column new -- to find old
			- row new < row old, column new < column old: row new ++ and column new ++ to find old */
move_needed_between_squares(ColumnNumberNewPiece, RowNumberOldPiece, ColumnNumberNewPiece, RowNumberOldPiece,
							ColumnNumberNewPiece, RowNumberOldPiece) .
																	
move_needed_between_squares(ColumnNumberNewPiece, RowNumberOldPiece, ColumnNumberOldPiece, RowNumberOldPiece,
	ColumnMovedNewPiece, RowNumberOldPiece) :- ColumnNumberNewPiece < ColumnNumberOldPiece,
												ColumnMovedNewPiece is ColumnNumberNewPiece + 1 .

move_needed_between_squares(ColumnNumberNewPiece, RowNumberOldPiece, ColumnNumberOldPiece, RowNumberOldPiece,
	ColumnMovedNewPiece, RowNumberOldPiece) :- ColumnNumberNewPiece > ColumnNumberOldPiece,
												ColumnMovedNewPiece is ColumnNumberNewPiece - 1 .
																	
move_needed_between_squares(ColumnNumberOldPiece, RowNumberNewPiece, ColumnNumberOldPiece, RowNumberOldPiece,
	ColumnNumberOldPiece, RowMovedNewPiece) :- RowNumberNewPiece > RowNumberOldPiece,
												RowMovedNewPiece is RowNumberNewPiece - 1 .
																	
move_needed_between_squares(ColumnNumberOldPiece, RowNumberNewPiece, ColumnNumberOldPiece, RowNumberOldPiece,
	ColumnNumberOldPiece, RowMovedNewPiece) :- RowNumberNewPiece < RowNumberOldPiece,
												RowMovedNewPiece is RowNumberNewPiece + 1 .

% diagonal moves.
move_needed_between_squares(ColumnNumberNewPiece, RowNumberNewPiece, ColumnNumberOldPiece, RowNumberOldPiece,
							ColumnMovedNewPiece, RowMovedNewPiece) :- RowNumberNewPiece > RowNumberOldPiece,
																		ColumnNumberNewPiece > ColumnNumberOldPiece,
																		RowMovedNewPiece is RowNumberNewPiece - 1,
																		ColumnMovedNewPiece is ColumnNumberNewPiece - 1 .

move_needed_between_squares(ColumnNumberNewPiece, RowNumberNewPiece, ColumnNumberOldPiece, RowNumberOldPiece,
							ColumnMovedNewPiece, RowMovedNewPiece) :- RowNumberNewPiece > RowNumberOldPiece,
																		ColumnNumberNewPiece < ColumnNumberOldPiece,
																		RowMovedNewPiece is RowNumberNewPiece - 1,
																		ColumnMovedNewPiece is ColumnNumberNewPiece + 1 .

move_needed_between_squares(ColumnNumberNewPiece, RowNumberNewPiece, ColumnNumberOldPiece, RowNumberOldPiece,
							ColumnMovedNewPiece, RowMovedNewPiece) :- RowNumberNewPiece < RowNumberOldPiece,
																		ColumnNumberNewPiece > ColumnNumberOldPiece,
																		RowMovedNewPiece is RowNumberNewPiece + 1,
																		ColumnMovedNewPiece is ColumnNumberNewPiece - 1 .

move_needed_between_squares(ColumnNumberNewPiece, RowNumberNewPiece, ColumnNumberOldPiece, RowNumberOldPiece,
							ColumnMovedNewPiece, RowMovedNewPiece) :- RowNumberNewPiece < RowNumberOldPiece,
																		ColumnNumberNewPiece < ColumnNumberOldPiece,
																		RowMovedNewPiece is RowNumberNewPiece + 1,
																		ColumnMovedNewPiece is ColumnNumberNewPiece + 1 .

% made to speed up the process by removing impossible ones
check_viable_amount_of_pieces_enclose(ColumnNumberNewPiece, _, ColumnNumberOldPiece, _, 
											AmountOfPiecesEnclosed) :- ColumnNumberOldPiece is ColumnNumberNewPiece + AmountOfPiecesEnclosed + 1 .

check_viable_amount_of_pieces_enclose(ColumnNumberNewPiece, _, ColumnNumberOldPiece, _, 
											AmountOfPiecesEnclosed) :- ColumnNumberOldPiece is ColumnNumberNewPiece - AmountOfPiecesEnclosed - 1 .

check_viable_amount_of_pieces_enclose(_, RowNumberNewPiece, _, RowNumberOldPiece, 
											AmountOfPiecesEnclosed) :- RowNumberOldPiece is RowNumberNewPiece + AmountOfPiecesEnclosed + 1 .

check_viable_amount_of_pieces_enclose(_, RowNumberNewPiece, _, RowNumberOldPiece, 
											AmountOfPiecesEnclosed) :- RowNumberOldPiece is RowNumberNewPiece - AmountOfPiecesEnclosed - 1 .


/* Succeeds when there are no possible moves in the given game */
no_more_legal_squares( BoardState ) :- valid_board_representation( BoardState ),
											\+ ( enclosing_piece( _, _, _, BoardState, _, _, _ ) ) .

/* Succeeds when:
	- the player given in the first argument does not have any more legal moves
	- in the game given in the second argument. */
% if enclosing piece doesn't find anything then the player can't move.
no_more_legal_squares( PlayerPiece, BoardState ) :- valid_board_representation( BoardState ),
														is_piece( PlayerPiece ), 
														\+ ( enclosing_piece( _, _, _, BoardState, _, _, _ ) ) .		


/* Recursive loop to play the game based on its arguments:
	- 1: current player
	- 2: current board state */

% no more moves in the game for anyone and there is a winner
play( _, BoardState ) :- no_more_legal_squares( BoardState ),
										and_the_winner_is( BoardState, Winner ),
										report_winner( Winner ) .

% no more moves in the game for anyone and it is a draw
play( _, BoardState ) :- no_more_legal_squares( BoardState ),
										\+ ( and_the_winner_is( BoardState, _ ) ),
										report_stalemate .

% no more moves for the current player, turn goes to other player
play( CurrentPlayer, BoardState ) :- no_more_legal_squares( CurrentPlayer, BoardState ),
										other_player( CurrentPlayer, OtherPlayerPiece ),
										play( OtherPlayerPiece, BoardState ) .

% Player can do a move, ask him for input, do the move, show the move and switch players (player vs player).
/* CODE FOR SECTION 3.6
play( CurrentPlayer, BoardState ) :- \+ (no_more_legal_squares( CurrentPlayer, BoardState )),
										is_piece(CurrentPlayer),
										valid_board_representation( BoardState ),
										%ask legal move and show it
										get_legal_move( CurrentPlayer, ColumnNumberNewPiece, RowNumberNewPiece, BoardState ),
										report_move( CurrentPlayer, ColumnNumberNewPiece, RowNumberNewPiece ), 
										%calculate new board
										fill_and_flip_squares( ColumnNumberNewPiece, RowNumberNewPiece, CurrentPlayer, BoardState, NewBoardState ),
										%show new board
										display_board( NewBoardState ),
										%switch to other player with new board
										other_player( CurrentPlayer, OtherPlayerPiece ),
										play( OtherPlayerPiece, NewBoardState ) . */

/* ------------------------ END HUMAN PLAYERS ------------------------ */

/* ------------------------ START HUMAN VS COMPUTER PLAYER ------------------------ */

% Player can do a move, ask him for input, do the move, show the move and switch players (player vs computer: player).
play( CurrentPlayer, BoardState ) :- \+ (no_more_legal_squares( CurrentPlayer, BoardState )),
										% human player is black player
										is_black( CurrentPlayer ),
										valid_board_representation( BoardState ),
										%ask legal move and show it 
										%    Or change this to also choose move to let computer fight computer
										%choose_move( CurrentPlayer, ColumnNumberNewPiece, RowNumberNewPiece, BoardState ),
										get_legal_move( CurrentPlayer, ColumnNumberNewPiece, RowNumberNewPiece, BoardState ),
										report_move( CurrentPlayer, ColumnNumberNewPiece, RowNumberNewPiece ), 
										%calculate new board
										fill_and_flip_squares( ColumnNumberNewPiece, RowNumberNewPiece, CurrentPlayer, BoardState, NewBoardState ),
										%show new board
										display_board( NewBoardState ),
										%switch to other player with new board
										other_player( CurrentPlayer, OtherPlayerPiece ),
										play( OtherPlayerPiece, NewBoardState ) . 

% Computer can do a move, do the move, show the move and switch players (player vs computer: computer).
play( CurrentPlayer, BoardState ) :- \+ (no_more_legal_squares( CurrentPlayer, BoardState )),
										% computer player is white player
										is_white( CurrentPlayer ),
										valid_board_representation( BoardState ),
										%calculate move and show it 
										choose_move( CurrentPlayer, ColumnNumberNewPiece, RowNumberNewPiece, BoardState ),
										report_move( CurrentPlayer, ColumnNumberNewPiece, RowNumberNewPiece ), 
										%calculate new board
										fill_and_flip_squares( ColumnNumberNewPiece, RowNumberNewPiece, CurrentPlayer, BoardState, NewBoardState ),
										%show new board
										display_board( NewBoardState ),
										%switch to other player with new board
										other_player( CurrentPlayer, OtherPlayerPiece ),
										play( OtherPlayerPiece, NewBoardState ) . 

/* Succeeds when legal move is choosen, dumb version: first legal move found */
choose_move( CurrentPlayer, ColumnNumberNewPiece, RowNumberNewPiece, 
				BoardState ) :- empty_square( ColumnNumberNewPiece, RowNumberNewPiece, BoardState ),
									enclosing_piece( ColumnNumberNewPiece, RowNumberNewPiece, CurrentPlayer, BoardState, _, _, _ ) .

/* ------------------------ END HUMAN VS COMPUTER PLAYER ------------------------ */	

























/* ------------------------------------------------------------------------------------------------
   ------------------------------------------------------------------------------------------------
   ------------------------------------------------------------------------------------------------
   ------------------------------------------------------------------------------------------------
   ------------------------------------------------------------------------------------------------ 
# Formative Othello Declarative Programming assignment @ VUB 2020-2021 

## Table of contents
- [Student info](#student-info)
- [Used software](#used-software)
- [Important files](#important-files)
- [Running the assignment](#running-the-assignment)

## Student info
- **Name**: Bontinck Lennert
- **StudentID**: 568702
- **Affiliation**: VUB - Master Computer Science: AI

## Used software
- [Visual Studio code](https://code.visualstudio.com/Download) with [VSC-Prolog plugin](https://marketplace.visualstudio.com/items?itemName=arthurwang.vsc-prolog)
- [SWI Prolog V8.2.4-1](https://www.swi-prolog.org/download/stable) from terminal using path variable.

## Important files
- Supplied and thus unedited files for assignment:
   - [fill.pl](fill.pl)
   - [io.pl](io.pl)
      - Small note: report_illegal/0 was removed from the export of the module since it was not defined in the io library and gave errors.
- The [assignment pdf](assignment.pdf)
- Single loadable file with comments and methods as prescribed in the assignment
   - [Bontinck_Lennert_568702_VUB_Othello.pl](Bontinck_Lennert_568702_VUB_Othello.pl)

## Running the assignment
- Make sure SWI Prolog is installed with the path variable set
- Go to the root of this GitHub repository in your terminal
- use:  ```swipl -s Bontinck_Lennert_568702_VUB_Othello.pl```
   
## Testing the created predicates
- Supplementary predicates:
   - valid_board_representation/1
      - valid_board_representation( X ).
         - Note: use w to write the whole list.
   - player_square/4
      - initial_board( BoardState), player_square( ColumnNumber, RowNumber, BoardState, PlayerPiece ) . 
- Board representation:
   - is_black/1
      - ```is_black( InputPiece ) .```
   - is_white/1
      - ```is_white( InputPiece ) .```
   - is_empty/1
      - ```is_empty( InputPiece ) .```
   - is_piece/1
      - ```is_piece( InputPiece ) .```
   - other_player/2
      - ```other_player( PlayerPiece1, PlayerPiece2 ) .```
   - row/3
      - ```row( RowNumber, BoardState, RowState ) .```
      - ```row( 8, BoardState, RowState ) .```
   - column/3
      - ```column( ColumnNumber, BoardState, RowState ) .```
      - ```column( 8, BoardState, RowState ) .```
   - square/4
      - ```square( ColumnNumber, RowNumber,  BoardState, SquareState) .```
      - ```square( 8, 8,  BoardState, SquareState) .```
   - empty square/3
      - ```empty_square( 8, 8,  BoardState) .```
   - initial_board/1
      - ```initial_board( X ) , display_board( X ) .```
   - empty_board/1
      - ```empty_board( X ) .```
- Spotting a winner:
   - count_pieces/3
      - ```initial_board( X ), count_pieces( X, Y, Z) .```
   - and_the_winner_is/2
      - ```initial_board( X ), and_the_winner_is( X, Y) .```
         - Draw; false
      - ```and_the_winner_is( [[*, *, *, *, *, *, *, *], [*, *, *, *, *, *, *, *], [*, *, *, *, *, *, *, *], [*, *, *, *, *, *, *, *], [*, *, *, *, *, *, *, *], [*, *, *, *, *, *, *, *], [*, *, *, *, *, *, *, *], [*, *, *, *, *, *, *, o]], Y) .```
- Running a game for 2 human players
   - enclosing_piece/7
      - ```initial_board( BoardState ), enclosing_piece( 3, 4, '*', BoardState, 5, 4, 1 ) .```
      - ```initial_board( BoardState ), enclosing_piece( ColumnNumberNewPiece, RowNumberNewPiece, '*', BoardState, ColumnNumberOldPiece, RowNumberOldPiece, 1 ) .```
   - no_more_legal_squares/1
      - ```initial_board( BoardState ), no_more_legal_squares( BoardState ) .```
   - no_more_legal_squares/2
      - ```initial_board( BoardState ),  no_more_legal_squares( PlayerPiece, BoardState ) .```
	  */