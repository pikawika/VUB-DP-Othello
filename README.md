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