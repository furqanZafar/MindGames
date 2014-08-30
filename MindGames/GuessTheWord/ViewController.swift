import Foundation
import UIKit

class GTWViewController: UIViewController {

    func _init() {
        var tiles = GTWTilesViewController()
        tiles.configure(4, rows: 5, word: "SWIFT", wordSelected: self.wordSelected)
        self.addChildViewController(tiles)
        self.view.addSubview(tiles.view)
        
        var label = UILabel(frame: CGRectMake(0, self.view.frame.height - 20, self.view.frame.width, 20))
        label.textAlignment = NSTextAlignment.Center
        label.text = "Hello!"
        self.label = label
        self.view.addSubview(label)
    }
    
    var label: UILabel!
    
    func wordSelected(word: String) {
        label.text = word
    }
    
    override func viewDidLoad() {
        _init()
    }
}
