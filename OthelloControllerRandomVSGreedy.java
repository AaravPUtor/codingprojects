package ca.utoronto.utm.assignment1.othello;

/**
 * The goal here is to print out the probability that Random wins and Greedy
 * wins as a result of playing 10000 games against each other with P1=Random and
 * P2=Greedy. What is your conclusion, which is the better strategy?
 * @author arnold
 *
 */
public class OthelloControllerRandomVSGreedy extends OthelloController {

	/**
	 * Constructs a new OthelloControllerRandomVSGreedy by calling the Controller super class then setting
	 * the player1 as a player with a random strategy and player two as a player with a greedy strategy.
	 */
	public OthelloControllerRandomVSGreedy() {
		super();
		this.player1 = new PlayerRandom(this.othello, OthelloBoard.P1);
		this.player2 = new PlayerGreedy(this.othello, OthelloBoard.P2);
	}

	/**
	 * Run main to execute the simulation and print out the two line results.
	 * Output looks like:
	 * Probability P1 wins=.75
	 * Probability P2 wins=.20
	 * @param args
	 */
	public static void main(String[] args) {
		int p1wins = 0, p2wins = 0, numGames = 10000;
		OthelloControllerRandomVSGreedy mygame = new OthelloControllerRandomVSGreedy();
		for(int i = 0; i < numGames; i++){
			mygame.play();
			if(mygame.othello.getWinner() == OthelloBoard.P1){
				p1wins++;
			}
			else if (mygame.othello.getWinner() == OthelloBoard.P2){
				p2wins++;
			}
			mygame = new OthelloControllerRandomVSGreedy();
		}

		System.out.println("Probability P1 wins=" + (float) p1wins / numGames);
		System.out.println("Probability P2 wins=" + (float) p2wins / numGames);
	}
}
