import Foundation
import UIKit

extension GuessTheWord {
    class TilesViewController : UIViewController {
        
        var cols: Int!
        var rows: Int!
        var targetWord: String!

        func configure(cols: Int, rows: Int, word: String) -> TilesViewController {
            self.cols = cols
            self.rows = rows
            self.targetWord = word
            return self
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = UIColor.blackColor()
            
            var r = CGFloat(100)/2
            var x = CGFloat(sqrt(3.0)) * r / 2
            var rows = self.rows
            var cols = self.cols
            
            self.view.bounds = CGRectMake(0, 0, (2 * CGFloat(cols) + 1) * x, 2 * r + (CGFloat(rows) - 1) * 3/2 * r)
            
            var fx = { (col:Int, row:Int) in
                (x - r) +
                    CGFloat(!even(row) ? (col - 1) * 2 : 2 * (col - 1) + 1) * x
            }
            
            var fy = { (col:Int, row:Int) in
                1.5 * (CGFloat(row) - 1) * r
            }
            
            
            var map = Map(cols: cols, rows: rows)
            map.addWord(self.targetWord)
            
            for node in map.allNodes() {
                var col = node.col
                var row = node.row
                var view = HexagonView(frame: CGRectMake(fx(col,row), fy(col,row), r*2,r*2))
                view.setLetter(node.letter)
                
                if node.occupied {
                    view.hexagonBackgroundColor = UIColor.orangeColor()
                    view.setNeedsDisplay()
                }
                
                self.view.addSubview(view)
                
            }
        }
    }
}