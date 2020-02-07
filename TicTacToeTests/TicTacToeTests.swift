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
}
