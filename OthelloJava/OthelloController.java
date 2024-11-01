package ca.utoronto.utm.assignment1.othello;

public class OthelloController {
    protected Othello othello;
    protected Player player1;
    protected Player player2;

    /**
     * Constructs a new Controller part of the game of Othello
     */
    public OthelloController(){
        this.othello = new Othello();
    }

    public void play(){
        if((player1 instanceof PlayerHuman) || (player2 instanceof PlayerHuman)){playHuman();}
        else{playAutomatic();}
    }

    /**
     * Begins the new game of this.othello, and continues till game is over
     * Prints out the details of the winner and about any moves made
     */
    private void playHuman() {

        while (!othello.isGameOver()) {
            this.report();

            Move move = null;
            char whosTurn = othello.getWhosTurn();

            if (whosTurn == OthelloBoard.P1)
                move = player1.getMove();
            if (whosTurn == OthelloBoard.P2)
                move = player2.getMove();

            this.reportMove(whosTurn, move);
            othello.move(move.getRow(), move.getCol());
        }
        this.reportFinal();
    }

    /**
     * Begins the new game of this.othello, and continues till game is over, returns the winner
     */
    private void playAutomatic() {
        while (!othello.isGameOver()) {
            Move move = null;
            char whosTurn = othello.getWhosTurn();

            if (whosTurn == OthelloBoard.P1)
                move = player1.getMove();
            if (whosTurn == OthelloBoard.P2)
                move = player2.getMove();

            if(move.getRow() == -1 && move.getCol() == -1){othello.nextPlayer();}
            othello.move(move.getRow(), move.getCol());
        }

    }

    private void reportMove(char whosTurn, Move move) {
        System.out.println(whosTurn + " makes move " + move + "\n");
    }

    private void report() {

        String s = othello.getBoardString() + OthelloBoard.P1 + ":"
                + othello.getCount(OthelloBoard.P1) + " "
                + OthelloBoard.P2 + ":" + othello.getCount(OthelloBoard.P2) + "  "
                + othello.getWhosTurn() + " moves next";
        System.out.println(s);
    }

    private void reportFinal() {

        String s = othello.getBoardString() + OthelloBoard.P1 + ":"
                + othello.getCount(OthelloBoard.P1) + " "
                + OthelloBoard.P2 + ":" + othello.getCount(OthelloBoard.P2)
                + "  " + othello.getWinner() + " won\n";
        System.out.println(s);
    }
}
