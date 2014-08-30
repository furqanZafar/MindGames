import Foundation
import UIKit

func eat<T>(x: T) -> () {
    return;
}

class GTWTilesViewController : UIViewController {
    
    var cols: Int!
    var rows: Int!
    var targetWord: String!
    var wordSelected : (String) -> () = eat

    func configure(cols: Int, rows: Int, word: String, wordSelected: (String) -> ()) -> GTWTilesViewController {
        self.cols = cols
        self.rows = rows
        self.targetWord = word
        self.wordSelected = wordSelected
        return self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()

        var r = self.view.frame.width / CGFloat(self.cols) / 2.0
        
        //var r = CGFloat(100)/2
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
        
        
        var map = GTWMap(cols: cols, rows: rows)
        map.addWord(self.targetWord)
        
        for node in map.allNodes() {
            var col = node.col
            var row = node.row
            var view = GTWHexagonView(frame: CGRectMake(fx(col,row), fy(col,row), r*2,r*2))
            view.setLetter(node.letter)
            
            self.view.addSubview(view)
            
        }
    }
    
    var hitCells : [GTWHexagonView] = []
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        self.hitCells = []
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        var point : CGPoint = touches.anyObject().locationInView(self.view)
        var hex = self.view.hitTest(point, withEvent: event)
        if var hex = hex as? GTWHexagonView {
            if hex.preciseHitTest(CGPoint(x: point.x - hex.frame.minX, y: point.y - hex.frame.minY)) {
                if hitCells.count > 1 && hitCells[hitCells.count - 2] == hex {
                    hitCells[hitCells.count - 1].deHighlight()
                    hitCells = Array(hitCells[0 ... hitCells.count - 2])
                }
                else if hitCells.filter({h in h == hex}).count == 0 {
                    hex.highlight()
                    hitCells.append(hex)
                }
                
                var word = hitCells.map({h in h.getLetter()}).reduce("", combine: +)
                self.wordSelected(word)
            }
        }
       
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        for v in self.hitCells {
            v.deHighlight()
        }
    }
}
