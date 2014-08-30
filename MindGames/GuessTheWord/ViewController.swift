import Foundation
import UIKit

struct GuessTheWord {
    
    class ViewController: UIViewController {

        func _init() {
            var tiles = TilesViewController()
            tiles.configure(4, rows: 5, word: "SWIFT")
            self.addChildViewController(tiles)
            self.view.addSubview(tiles.view)
        }
        
        override func viewDidLoad() {
            _init()
        }
    }
}