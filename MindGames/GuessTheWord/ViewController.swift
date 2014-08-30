import Foundation
import UIKit

class GTWViewController: UIViewController {

    func _init() {
        var tiles = GTWTilesViewController()
        tiles.configure(4, rows: 5, word: "SWIFT")
        self.addChildViewController(tiles)
        self.view.addSubview(tiles.view)
    }
    
    override func viewDidLoad() {
        _init()
    }
}
