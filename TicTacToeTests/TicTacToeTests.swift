import XCTest
@testable import TicTacToe

class TicTacToeTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTurn() {
        let players = 2
        var turn = 0
        
        turn = (turn + 1) % players
        XCTAssertTrue(turn == 1)
        turn = (turn + 1) % players
        XCTAssertTrue(turn == 0)
        turn = (turn + 1) % players
        XCTAssertTrue(turn == 1)
    }
    
    func testBoardRepresentation() {
        /*
            8 7 6   X O X
            5 4 3   O X O
            2 1 0   O x O
            
         Each player move corresponds to a 9 bit encoded value corresponding to the 9 possible slots
         The board is represented as a 18 bit encoded value with two distinct part. Bits [0 - 8] are player X representation, and bits [9 - 18] are for player O
         
            - - X       - - 6           - - 6       - - -
            O - -   ==  5 - -   ==  (   - - -   |   5 - -   )
            - O X       - 1 0           - - 0       - 1 -
            
        */
        
        let X = (1 << 6) | (1 << 0)
        let O = (1 << 5) | (1 << 1)
        let board = X | O << 9
        
        let X_rev = board & 0b111111111
        let O_rev = (board >> 9) & 0b111111111
        
        XCTAssertTrue(X_rev == X)
        XCTAssertTrue(O_rev == O)
    }
    
    func testAuthorizedAndUnauthorizedMove() {
        /*
         Given a board sequence, verify if a move is authorized to play (not already binary encoded)
         Board: - - -
                - - -
                - - X
         
         Player O play 0 -> should be unauthorized
         Player O play 1 -> should be authorized
         
         To know how to recognize an authorized move, we can compare the value of the current board and the result of "board OR slot"
         */
        
        let board = 0b000000000000000001
        let X_board = board & 0b111111111 //Filtered board for X slots
        let O_board = board >> 9 //Filtered board for O slots
        
        //The slot required to move on is equal to 1 shifted by slot
        var O_move = 1 << 0
        
        //Verify if the slot is free of X or O, meaning a OR operator should increase the board value for each separated board (X's and O's)
        let unauthorized_move = (X_board | O_move) > X_board && (O_board | O_move) > O_board
        
        //Verify that moving on the slot 0 is not possible
        XCTAssertFalse(unauthorized_move)
        
        O_move = 1 << 1
        let authorized_move = (X_board | O_move) > X_board && (O_board | O_move) > O_board
        XCTAssertTrue(authorized_move)
    }
    
    func testVerticalRight() {
        /*
        Given a board sequence, verify if a move in slot 6 by X is winning
        Board: - - -        - - -       - - -       - - -       - - X
               - - -    >   - - -   >   - - X   >   - O X   >   - O X   > X win
               - - X        - O X       - O X       - O X       - O X
        
        To know verify the winning value, we use a AND operator on X's board and the vertical right set represented by 001001001
        */
        
        let turn = 0 //Meaning its X turn
        let board = 0b000010010001001001 //Meaning the slot played by X was successfully encoded
        let X_board = (board >> (9 * turn)) & 0b111111111 //9 * turn to shift the board by 9 bits if its O's turn
        let pattern = 0b001001001 //Vertical right alignment
        
        let isWon = (X_board & pattern) == pattern
        XCTAssertTrue(isWon)
    }
    
    func testVerticalRightGame() {
        /*
        Given a board sequence, verify if a move in slot 6 by X is winning using the game class object
        Board: - - -        - - -       - - -       - - -       - - X
               - - -    >   - - -   >   - - X   >   - O X   >   - O X   > X win
               - - X        - O X       - O X       - O X       - O X
        
        The game object should return the .won game state
        */
        let game = Game()

        game.play(0)
        game.play(1)
        game.play(3)
        game.play(4)
        game.play(6)
        
        XCTAssertTrue(game.state == Game.GameState.won(winner: 0, set: .vertical_2))
    }
    
    func testUnsolvableGame() {
        /*
        Given that draw board sequence, verify if the game object returns the proper state
        Board: - - -        - - -       - - -       - - -                O X O
               - - -    >   - - -   >   - - -   >   - - O   >   ...   >  X O O   > draw
               - - X        - O X       X O X       X O X                X O X
        
        The game object should return the .draw game state
        */
        let game = Game()
        game.play(0)
        game.play(1)
        game.play(2)
        game.play(3)
        game.play(6)
        game.play(4)
        game.play(5)
        game.play(7)
        game.play(8)
        
        XCTAssertTrue(game.state == Game.GameState.draw)
    }
    
    func testUnauthMoveGame() {
        /*
        Verify if the game object prevents playing on an played slot
        The game object should return the .running game state and game.pturn should stay the same if many attempts are done on a played slot
        */
        let game = Game()
        game.play(0) //pturn = 1 after successfully played slot 0
        game.play(1) //pturn = 0 after successfully played slot 1
        game.play(1) //pturn remains 0
        game.play(1) //pturn remains 0
        game.play(1) //pturn remains 0
        game.play(1) //pturn remains 0
        
        XCTAssertTrue(game.pturn == 0)
    }
}
