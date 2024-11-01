package ca.utoronto.utm.assignment1.othello;
/**
 *
 * Represent a move made in an Othello game, with a row and columm value. This class enables printing and representing
 * the row and column value of a move and to represent a Move in coordinate form.
 * @author aarav
 *
 */
public class Move {
	private int row, col;

	/**
	 *
	 * Construct a new Move with row and column values
	 * @param row the row value for a move
	 * @param col the column value of a move
	 * @author aarav
	 *
	 */
	public Move(int row, int col) {
		this.row = row;
		this.col = col;
	}

	/**
	 *
	 * returns the integer row corresponding to the move
	 * @author aarav
	 *
	 */
	public int getRow() {
		return row;
	}

	/**
	 *
	 * returns the integer column corresponding to the move
	 * @author aarav
	 *
	 */
	public int getCol() {
		return col;
	}

	/**
	 *
	 * Prints out the moves in the form <row></row>
	 * @author aarav
	 *
	 */
	public String toString() {
		return "(" + this.row + "," + this.col + ")";
	}
}
