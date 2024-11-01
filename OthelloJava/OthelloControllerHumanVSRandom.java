package ca.utoronto.utm.assignment1.othello;

/**
 * This controller uses the Model classes to allow the Human player P1 to play
 * the computer P2. The computer, P2 uses a random strategy. 
 * 
 * @author arnold
 *
 */
public class OthelloControllerHumanVSRandom extends OthelloController {

	/**
	 * Constructs a new OthelloControllerRandomVSGreedy by calling the Controller super class then setting
	 * the player1 as a human player and player two as a player with a random strategy.
	 */
	public OthelloControllerHumanVSRandom() {

		super();
		player1 = new PlayerHuman(this.othello, OthelloBoard.P1);
		player2 = new PlayerRandom(this.othello, OthelloBoard.P2);
	}

	/**
	 * Run main to play a Human (P1) against the computer P2. 
	 * The computer uses a random strategy, that is, it randomly picks 
	 * one of its possible moves.
	 * The output should be almost identical to that of OthelloControllerHumanVSHuman.

	 * @param args
	 */
	public static void main(String[] args) {
		
		OthelloControllerHumanVSRandom oc = new OthelloControllerHumanVSRandom();
		oc.play(); // this should work
	}
}
