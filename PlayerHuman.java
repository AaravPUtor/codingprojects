package ca.utoronto.utm.assignment1.othello;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

/**
 * Create a human player who makes a move by user input on the console
 * ensure that the user input is valid, and whether the inputted move is viable.
 * @author arnold
 *
 */
public class PlayerHuman extends Player {
	
	private static final String INVALID_INPUT_MESSAGE = "Invalid number, please enter 1-8";
	private static final String IO_ERROR_MESSAGE = "I/O Error";
	private static BufferedReader stdin = new BufferedReader(new InputStreamReader(System.in));

	public PlayerHuman(Othello othello, char player) {
		super(othello, player);
	}

	@Override
	/**
	 * Get the move from a user input by obtaining the appropriate row move input and column move input
	 * only accept the input if it is valid, set values for row and col and return a new Move with row and col
	 * @author arnold
	 */
	public Move getMove() {
		int row = getMove("row: ");
		int col = getMove("col: ");
		return new Move(row, col);
	}

	private int getMove(String message) {
		
		int move, lower = 0, upper = 7;
		while (true) {
			try {
				System.out.print(message);
				String line = PlayerHuman.stdin.readLine();
				move = Integer.parseInt(line);
				if (lower <= move && move <= upper) {
					return move;
				} else {
					System.out.println(INVALID_INPUT_MESSAGE);
				}
			} catch (IOException e) {
				System.out.println(INVALID_INPUT_MESSAGE);
				break;
			} catch (NumberFormatException e) {
				System.out.println(INVALID_INPUT_MESSAGE);
			}
		}
		return -1;
	}
}
