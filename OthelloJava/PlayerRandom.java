package ca.utoronto.utm.assignment1.othello;

import java.util.ArrayList;
import java.util.Random;

/**
 * PlayerRandom makes a move by first determining all possible moves that this
 * player can make, putting them in an ArrayList, and then randomly choosing one
 * of them.
 * 
 * @author arnold
 *
 */
public class PlayerRandom extends Player {
	
	private Random rand = new Random();
	private ArrayList<Move> possiblePlays = new ArrayList<Move>();

	/**
	 * Constructs a new Player Random part of a game of Othello, and calls the abstract class Player to initialise
	 * a Player.
	 * @param othello the game of Othello that PlayerRandom is a player of
	 * @author aarav
	 */
	public PlayerRandom(Othello othello, char player) {
		super(othello, player);
	}

	private void setupPossiblePlays() {
		possiblePlays = new ArrayList<>();
		OthelloBoard boarduse = othello.getBoardCopy();
		for (int row = 0; row < Othello.DIMENSION; row++) {
			for (int col = 0; col < Othello.DIMENSION; col++) {
				if (boarduse.move(row, col, player)) {
					possiblePlays.add(new Move(row, col));
				}
				boarduse = othello.getBoardCopy();
			}
		}
	}

	@Override
	/**
	 * return the move from a user input by choosing a random move from the array of possiblePlays
	 * if there are any moves possible, else return Move with row and column -1 and -1
	 * @author arnold
	 */
	public Move getMove(){
		setupPossiblePlays();
		if(possiblePlays.isEmpty()){return new Move(-1, -1);}
		return possiblePlays.get(rand.nextInt(0, possiblePlays.size()));
	}
}
