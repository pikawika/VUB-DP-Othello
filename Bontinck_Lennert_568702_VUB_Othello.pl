/*
Single loadable file for the Othello assignment

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
																valid_board_representation( BoardState ),
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
												[EmptyPiece, EmptyPiece, EmptyPiece, EmptyPiece, EmptyPiece, EmptyPiece, EmptyPiece, EmptyPiece]].

/* Ssucceeds when its argument unies with a representation of the board with distinct variables in the places where the pieces would normally go. */
empty_board( BoardState ) :- BoardState = [[_, _, _, _, _, _, _, _],
											[_, _, _, _, _, _, _, _],
											[_, _, _, _, _, _, _, _],
											[_, _, _, _, _, _, _, _],
											[_, _, _, _, _, _, _, _],
											[_, _, _, _, _, _, _, _],
											[_, _, _, _, _, _, _, _],
											[_, _, _, _, _, _, _, _]].