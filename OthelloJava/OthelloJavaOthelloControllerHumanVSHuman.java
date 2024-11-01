package ca.utoronto.utm.assignment1.othello;

/**
 * Run the main from this class to play two humans against eachother. Only
 * minimal modifications to this class are permitted.
 * 
 * @author arnold
 *
 */
public class OthelloControllerHumanVSHuman extends OthelloController {
	/**
	 * Constructs a new OthelloControllerRandomVSGreedy by calling the Controller super class then setting
	 * the player1 as a human player and player two as a human player.
	 */
	public OthelloControllerHumanVSHuman() {
		super();
		player1 = new PlayerHuman(this.othello, OthelloBoard.P1);
		player2 = new PlayerHuman(this.othello, OthelloBoard.P2);
	}

	/**
	 * Run main to play two Humans against each other at the console.
	 * @param args
	 */
	public static void main(String[] args) {
		
		OthelloControllerHumanVSHuman oc = new OthelloControllerHumanVSHuman();
		oc.play();
	}

}
