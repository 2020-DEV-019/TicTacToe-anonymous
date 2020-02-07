import Foundation

class Game {
    var pturn = 0
    var board = 0
    
    enum GameState {
        case running
        case won(winner: Int, set: WinningSet)
        case draw
    }
    
    enum WinningSet: Int {
        case unsolvable
        case horizontal_0   = 0b111000000
        case horizontal_1   = 0b000111000
        case horizontal_2   = 0b000000111
        case vertical_0     = 0b100100100
        case vertical_1     = 0b010010010
        case vertical_2     = 0b001001001
        case diagonal_0     = 0b100010001
        case diagonal_1     = 0b001010100
    }
    
    func play(_ slot: Int) -> GameState {
        return .running
    }
    
    func canMove(_ slot: Int) -> Bool {
        return false
    }
    
    func compute(_ board: Int, slot: Int) -> WinningSet? {
        return nil
    }
    
    func turn() {
        pturn = (pturn + 1) % 2
    }
}
