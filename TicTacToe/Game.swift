import Foundation

class Game {
    var pturn = 0
    var board = 0
    var state: GameState = .running
    
    enum GameState: Equatable {
        case running
        case won(winner: Int, set: WinningSet)
        case draw
        
        static func ==(lhs: GameState, rhs: GameState) -> Bool {
            switch (lhs, rhs) {
            case (.running, .running), (.draw, .draw):
                return true
            case (.won(let lw, let ls), .won(let rw, let rs)):
                return lw == rw && ls == rs
            default:
                return false
            }
        }
    }
    
    enum WinningSet: Int, CaseIterable {
        case unsolvable     = 0b111111111
        case horizontal_0   = 0b111000000
        case horizontal_1   = 0b000111000
        case horizontal_2   = 0b000000111
        case vertical_0     = 0b100100100
        case vertical_1     = 0b010010010
        case vertical_2     = 0b001001001
        case diagonal_0     = 0b100010001
        case diagonal_1     = 0b001010100
    }
    
    /*
    Game logic. Returns a Bool value either a move has been done or not. Updates the turn and the state of the game according to the mapping of the resulting computation.
    */
    @discardableResult
    func play(_ slot: Int) -> Bool {
        if canMove(slot) {
            if let result = compute(slot) {
                if case .unsolvable = result {
                    state = .draw
                } else {
                    state = .won(winner: pturn, set: result)
                }
            } else {
                turn()
            }
            
            return true
        }
        
        state = .running
        return false
    }
    
    /*
    Verify if a move on the slot passed as parameter is authorized or not
    */
    func canMove(_ slot: Int) -> Bool {
        let p1 = board & 0b111111111
        let p2 = (board >> 9) & 0b111111111
        return (p1 | (1 << slot)) > p1 && (p2 | (1 << slot)) > p2
    }
    
    /*
    Assign the played slot to the board and returns a set if applicable, nil otherwise
    */
    func compute(_ slot: Int) -> WinningSet? {
        board |= (1 << slot) << (9 * pturn)
        let p1 = board & 0b111111111
        let p2 = (board >> 9) & 0b111111111
        
        for testSet in WinningSet.allCases {
            if let set = WinningSet(rawValue: (board >> (9 * pturn)) & testSet.rawValue) {
                return set
            }
        }
        
        if let set = WinningSet(rawValue: p1 | p2), set == .unsolvable {
            return set
        }
        
        return nil
    }
    
    /*
    Toggles player turns
    */
    func turn() {
        pturn = (pturn + 1) % 2
    }
}
