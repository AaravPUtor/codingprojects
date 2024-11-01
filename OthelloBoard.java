package ca.utoronto.utm.assignment1.othello;

/**
 * Keep track of all of the tokens on the board. This understands some
 * interesting things about an Othello board, what the board looks like at the
 * start of the game, what the players tokens look like ('X' and 'O'), whether
 * given coordinates are on the board, whether either of the players have a move
 * somewhere on the board, what happens when a player makes a move at a specific
 * location (the opposite players tokens are flipped).
 * 
 * Othello makes use of the OthelloBoard.
 * 
 * @author arnold
 *
 */
public class OthelloBoard {
	
	public static final char EMPTY = ' ', P1 = 'X', P2 = 'O', BOTH = 'B';
	private int dim = 8;
	private char[][] board;
	private final int[][] dirList = {{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}};

	/**
	 *
	 * Construct a new OthelloBoard with dimensions set by a parameter, setting the 4 centre positions of the square
	 * board to alternating P1 and P2 characters.
	 * @param dim the dimensions (rows and columns) of the OthelloBoard
	 */
	public OthelloBoard(int dim) {
		this.dim = dim;
		board = new char[this.dim][this.dim];
		for (int row = 0; row < this.dim; row++) {
			for (int col = 0; col < this.dim; col++) {
				this.board[row][col] = EMPTY;
			}
		}
		int mid = this.dim / 2;
		this.board[mid - 1][mid - 1] = this.board[mid][mid] = P1;
		this.board[mid][mid - 1] = this.board[mid - 1][mid] = P2;
	}
	/**
	 *
	 * @return dimension of the othello board
	 */
	public int getDimension() {
		return this.dim;
	}

	/**
	 * 
	 * @param player either P1 or P2
	 * @return P2 or P1, the opposite of player
	 */
	public static char otherPlayer(char player) {
		if (player == P1) {return P2;} //checking if parameter player is P1
		else if (player == P2){return P1;} //checking if parameter player is P2
		return EMPTY; //Returns EMPTY incase empty spot was inputted
	}

	/**
	 * 
	 * @param row starting row, in {0,...,dim-1} (typically {0,...,7})
	 * @param col starting col, in {0,...,dim-1} (typically {0,...,7})
	 * @return P1,P2 or EMPTY, EMPTY is returned for an invalid (row,col)
	 */
	public char get(int row, int col) {
		if(!validCoordinate(row, col)){return EMPTY;}
		return this.board[row][col];
	}

	/**
	 * 
	 * @param row starting row, in {0,...,dim-1} (typically {0,...,7})
	 * @param col starting col, in {0,...,dim-1} (typically {0,...,7})
	 * @return whether (row,col) is a position on the board. Example: (6,12) is not
	 *         a position on the board.
	 */
	private boolean validCoordinate(int row, int col) {return ((0 <= row) && (row < this.dim) && (0 <= col) && (col < this.dim));}

	/**
	 * Check if there is an alternation of P1 next to P2, starting at (row,col) in
	 * direction (drow,dcol). That is, starting at (row,col) and heading in
	 * direction (drow,dcol), you encounter a sequence of at least one P1 followed
	 * by a P2, or at least one P2 followed by a P1. The board is not modified by
	 * this method. Why is this method important? If
	 * alternation(row,col,drow,dcol)==P1, then placing P1 right before (row,col),
	 * assuming that square is EMPTY, is a valid move, resulting in a collection of
	 * P2 being flipped.
	 * 
	 * @param row  starting row, in {0,...,dim-1} (typically {0,...,7})
	 * @param col  starting col, in {0,...,dim-1} (typically {0,...,7})
	 * @param drow the row direction, in {-1,0,1}
	 * @param dcol the col direction, in {-1,0,1}
	 * @return P1, if there is an alternation P2 ...P2 P1, or P2 if there is an
	 *         alternation P1 ... P1 P2 in direction (dx,dy), EMPTY if there is no
	 *         alternation
	 */
	private char alternation(int row, int col, int drow, int dcol) {
		int userow = row;
		int usecol = col;

		// if the direction is 0, 0 then there is no movement to check for alternation, thus EMPTY
		if ((drow == 0 && dcol == 0)) {return EMPTY;}
		while (validCoordinate(userow, usecol) ) {
			char firstplayer = board[row][col];

			//if there is an empty space then alternation is not present, thus EMPTY
			if(board[userow][usecol] == EMPTY){return EMPTY;}

			//if we see that the current element is equal to otherPlayer of player at row and col, then alternation is there
			if (board[userow][usecol] == otherPlayer(firstplayer)){
				return otherPlayer(firstplayer);
			}
			// increment the row and column referenced
			userow = userow + drow;
			usecol = usecol + dcol;
		}
		//return EMPTY if the coordinates are invalid
		return EMPTY;

	}

	/**
	 * flip all other player tokens to player, starting at (row,col) in direction
	 * (drow, dcol). Example: If (drow,dcol)=(0,1) and player==O then XXXO will
	 * result in a flip to OOOO
	 * 
	 * @param row    starting row, in {0,...,dim-1} (typically {0,...,7})
	 * @param col    starting col, in {0,...,dim-1} (typically {0,...,7})
	 * @param drow   the row direction, in {-1,0,1}
	 * @param dcol   the col direction, in {-1,0,1}
	 * @param player Either OthelloBoard.P1 or OthelloBoard.P2, the target token to
	 *               flip to.
	 * @return the number of other player tokens actually flipped, -1 if this is not
	 *         a valid move in this one direction, that is, EMPTY or the end of the
	 *         board is reached before seeing a player token.
	 */
	private int flip(int row, int col, int drow, int dcol, char player) {
		int count = 0; //return value denoting the number flipped
		int rowuse = row + drow;
		int coluse = col + dcol;

		// checks if the move is possible and valid before performing any flipping, returns -1 if not possible
		if (hasMove(row, col, drow, dcol) != player) {return -1;}

		//while loop flips values until the target "player" is reached
		while (board[rowuse][coluse] == otherPlayer(player) ) {
			board[rowuse][coluse] = player;
			count++;
			rowuse = rowuse + drow;
			coluse = coluse + dcol;
		}
		return count;
	}

	/**
	 * Return which player has a move (row,col) in direction (drow,dcol).
	 * 
	 * @param row  starting row, in {0,...,dim-1} (typically {0,...,7})
	 * @param col  starting col, in {0,...,dim-1} (typically {0,...,7})
	 * @param drow the row direction, in {-1,0,1}
	 * @param dcol the col direction, in {-1,0,1}
	 * @return P1,P2,EMPTY
	 */
	private char hasMove(int row, int col, int drow, int dcol) {
		//checks if the position (row, col) is playable and whether the input is a valid coordinate
		if(board[row][col] == EMPTY && validCoordinate(row, col)) {
			return alternation(row + drow, col + dcol, drow, dcol);
		}
		// else, neither player has a move
		return EMPTY;
    }

	/**
	 * 
	 * @return whether P1,P2 or BOTH have a move somewhere on the board, EMPTY if
	 *         neither do.
	 */
	public char hasMove() {

		boolean p1HasMove = false;
		boolean p2HasMove = false;
		//loops through all possible rows
		for (int row = 0; row < this.dim; row++) {
			//loops through all possible columns
			for (int col = 0; col < this.dim; col++) {
				//loops through a list dirList that contains the different pairs of values for drow, dcol
                for (int[] ints : dirList) {
                    int drow = ints[0];
                    int dcol = ints[1];
					if (! p1HasMove && hasMove(row, col, drow, dcol) == P1) {
						p1HasMove = true;}
					else if (! p2HasMove && hasMove(row, col, drow, dcol) == P2) {
						p2HasMove = true;
					}
                }
			}
		}
		//checks whether neither, either, or both flags for p1/p2 HasMove are true, and returns accordingly
		if (p1HasMove && p2HasMove) {return BOTH;}
		if (p1HasMove) {return P1;}
		if (p2HasMove) {return P2;}
		return EMPTY;

	}

	/**
	 * Make a move for player at position (row,col) according to Othello rules,
	 * making appropriate modifications to the board. Nothing is changed if this is
	 * not a valid move.
	 * 
	 * @param row    starting row, in {0,...,dim-1} (typically {0,...,7})
	 * @param col    starting col, in {0,...,dim-1} (typically {0,...,7})
	 * @param player P1 or P2
	 * @return true if player moved successfully at (row,col), false otherwise
	 */
	public boolean move(int row, int col, char player) {
		// if the origin position of the move is invalid, or the origin position is not empty, the move is not possible
		if (! validCoordinate(row, col) || board[row][col] != EMPTY) {return false;}
		boolean checkFlippable = false; // indicates whether a flip has occurred for the specified player

		for (int[] ints : dirList) {
			int drow = ints[0];
			int dcol = ints[1];
			if (hasMove(row, col, drow, dcol) == player && flip(row, col, drow, dcol, player) != -1) {checkFlippable = true;}
		}
		if (checkFlippable) {
			board[row][col] = player;
			return true;
		}
		return false;
	}

	/**
	 * 
	 * @param player P1 or P2
	 * @return the number of tokens on the board for player
	 */
	public int getCount(char player) {
		int count = 0;
		for (int row = 0; row < this.dim; row++) {
			for (int col = 0; col < this.dim; col++) {
				if (this.board[row][col] == player){count++;}
			}
		}
		return count;
	}

	/**
	 * Helper method to copy the board of the current instance to a new board
	 *
	 * @param dimuse Dimension of OthelloBoard to create
	 * @return a new OthelloBoard with an identical board as this.board
	 */
	public OthelloBoard setBoardCopy(int dimuse) {
		OthelloBoard copiedBoard = new OthelloBoard(dimuse);
		for (int r = 0; r < this.dim; r++) {
			for(int c = 0; c < this.dim; c++) {
				copiedBoard.board[r][c] = board[r][c];
			}
		}
		return copiedBoard;
	}

	/**
	 * Method used for testing only, to set a board to a particular state to test Player behaviour
	 *
	 * @param row represents the row on the board at which we want to set a player on
	 * @param col represents the column on the board at which we want to set a player on
	 * @param player represents the player to set at position row, col on the board
	 */
	public void setPlayeratPositon(int row, int col, char player) {
		this.board[row][col] = player;
	}

	/**
	 * @return a string representation of this, just the play area, with no
	 *         additional information. DO NOT MODIFY THIS!!
	 */
	public String toString() {
		/**
		 * See assignment web page for sample output.
		 */
		String s = "";
		s += "  ";
		for (int col = 0; col < this.dim; col++) {
			s += col + " ";
		}
		s += '\n';

		s += " +";
		for (int col = 0; col < this.dim; col++) {
			s += "-+";
		}
		s += '\n';

		for (int row = 0; row < this.dim; row++) {
			s += row + "|";
			for (int col = 0; col < this.dim; col++) {
				s += this.board[row][col] + "|";
			}
			s += row + "\n";

			s += " +";
			for (int col = 0; col < this.dim; col++) {
				s += "-+";
			}
			s += '\n';
		}
		s += "  ";
		for (int col = 0; col < this.dim; col++) {
			s += col + " ";
		}
		s += '\n';
		return s;
	}

	/**
	 * A quick test of OthelloBoard. Output is on assignment page.
	 * 
	 * @param args
	 */
	public static void main(String[] args) {
		
		OthelloBoard ob = new OthelloBoard(8);
		System.out.println(ob);
		System.out.println("getCount(P1)=" + ob.getCount(P1));
		System.out.println("getCount(P2)=" + ob.getCount(P2));
		for (int row = 0; row < ob.dim; row++) {
			for (int col = 0; col < ob.dim; col++) {
				ob.board[row][col] = P1;
			}
		}
		System.out.println(ob);
		System.out.println("getCount(P1)=" + ob.getCount(P1));
		System.out.println("getCount(P2)=" + ob.getCount(P2));

		// Should all be blank
		for (int drow = -1; drow <= 1; drow++) {
			for (int dcol = -1; dcol <= 1; dcol++) {
				System.out.println("alternation=" + ob.alternation(4, 4, drow, dcol));
			}
		}

		for (int row = 0; row < ob.dim; row++) {
			for (int col = 0; col < ob.dim; col++) {
				if (row == 0 || col == 0) {
					ob.board[row][col] = P2;
				}
			}
		}
		System.out.println(ob);

		// Should all be P2 (O) except drow=0,dcol=0
		for (int drow = -1; drow <= 1; drow++) {
			for (int dcol = -1; dcol <= 1; dcol++) {
				System.out.println("direction=(" + drow + "," + dcol + ")");
				System.out.println("alternation=" + ob.alternation(4, 4, drow, dcol));
			}
		}

		// Can't move to (4,4) since the square is not empty
		System.out.println("Trying to move to (4,4) move=" + ob.move(4, 4, P2));

		ob.board[4][4] = EMPTY;
		ob.board[2][4] = EMPTY;

		System.out.println(ob);

		for (int drow = -1; drow <= 1; drow++) {
			for (int dcol = -1; dcol <= 1; dcol++) {
				System.out.println("direction=(" + drow + "," + dcol + ")");
				System.out.println("hasMove at (4,4) in above direction =" + ob.hasMove(4, 4, drow, dcol));
			}
		}
		System.out.println("who has a move=" + ob.hasMove());
		System.out.println("Trying to move to (4,4) move=" + ob.move(4, 4, P2));
		System.out.println(ob);
	}

}
