import UIKit

class GameViewController: UIViewController {

    @IBOutlet var slots: [UIImageView]!
    @IBOutlet var turnPicture: UIImageView!
    @IBOutlet var state: UILabel!
    
    var game: Game!
    var currentTurn = 0
    var cross = UIImage(named: "cross")!
    var circle = UIImage(named: "circle")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        reloadGame()
    }

    /*
    Remove IB's templating values
    */
    func initUI() {
        for slot in slots {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(tap(gesture:)))
            slot.addGestureRecognizer(gesture)
        }
    }
    
    /*
    Reload the screen with initialized values
    */
    func reloadGame() {
        game = Game()
        currentTurn = 0
        state.text = "Plays"
        turnPicture.image = cross
        for slot in slots {
            slot.image = nil
        }
    }
    
    /*
    Game UI logic. Plays a slot if possible, then update pictures according to the current turn and the new one.
    If draw or win, shows a popup with a button to reset the game
    */
    func play(slot: Int, input: UIImageView) {
        if game.play(slot) {
            assignPicture(imageView: input, turn: currentTurn)
            assignPicture(imageView: turnPicture, turn: game.pturn)
            currentTurn = game.pturn
            switch game.state {
            case .draw:
                state.text = "Draw"
                popup(title: "Draw")
            case .won:
                state.text = "Win"
                popup(title: "Win")
            default:
                break
            }
        }
    }
    
    @objc
    func tap(gesture: UITapGestureRecognizer) {
        guard let view = gesture.view as? UIImageView else {
            return
        }
        
        play(slot: view.tag, input: view)
    }
    
    func assignPicture(imageView: UIImageView, turn: Int) {
        imageView.image = turn == 0 ? cross : circle
    }
    
    func popup(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Reload", style: .default, handler: { [unowned self] _ in
            self.reloadGame()
        }))
        self.present(alert, animated: true)
    }
}

