package ca.utoronto.utm.assignment1.othello;

/**
 * PlayerGreedy makes a move by considering all possible moves that the player
 * can make. Each move leaves the player with a total number of tokens.
 * getMove() returns the first move which maximizes the number of
 * tokens owned by this player. In case of a tie, between two moves,
 * (row1,column1) and (row2,column2) the one with the smallest row wins. In case
 * both moves have the same row, then the smaller column wins.
 * 
 * Example: Say moves (2,7) and (3,1) result in the maximum number of tokens for
 * this player. Then (2,7) is returned since 2 is the smaller row.
 * 
 * Example: Say moves (2,7) and (2,4) result in the maximum number of tokens for
 * this player. Then (2,4) is returned, since the rows are tied, but (2,4) has
 * the smaller column.
 * 
 * See the examples supplied in the assignment handout.
 * 
 * @author arnold
 *
 */

public class PlayerGreedy extends Player {

	/**
	 * Constructs a new Player Random part of a game of Othello, and calls the abstract class Player to initialise
	 * a Player.
	 * @param othello the game of Othello that PlayerGreedy is part of
	 * @param player either OthelloBoard.P1 or OthelloBoard.P2, INDICATING WHICH
	 * @author aarav
	 */
	public PlayerGreedy(Othello othello, char player) {
		super(othello, player);
	}

	@Override
	/**
	 * Get the move from a user input by obtaining the first row and column that yields the highest number
	 * of tokens on the board for a player, returning a new Move with the respective row and col values
	 * @author arnold
	 **/
	public Move getMove() {
		int currbest = othello.getCount(player);
		OthelloBoard boarduse = othello.getBoardCopy();

			int rowsave = -1;
			int colsave = -1;

			for (int row = 0; row < Othello.DIMENSION; row++) {
				for (int col = 0; col < Othello.DIMENSION; col++) {
					boolean check = boarduse.move(row, col, this.player);
					if (check) {
						if (boarduse.getCount(player) > currbest) {
							currbest = boarduse.getCount(player);
							rowsave = row;
							colsave = col;

						}

					}
					boarduse = othello.getBoardCopy();
				}

			}

		return new Move(rowsave, colsave);
	}
}