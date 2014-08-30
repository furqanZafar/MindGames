// Playground - noun: a place where people can play

import XCPlayground
import Foundation
import UIKit
import SpriteKit

var even = { x in x%2 == 0 }
var odd = { x in !even(x) }

var letters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")

func randomLetter() -> String {
    return "" + String(letters[Int(arc4random_uniform(UInt32(letters.count)))])
}


var targetWord = "SWIFT"


class Node {
    var col : Int
    var row: Int
    var letter: String
    var occupied: Bool
    init(col : Int, row : Int, letter: String, occupied: Bool) {
        self.col = col
        self.row = row
        self.letter = letter
        self.occupied = occupied
    }
    
    func setLetter(letter: String) {
        self.letter = letter
        self.occupied = true
    }
    
    func clearLetter() {
        self.setLetter(randomLetter())
        self.occupied = false
    }
}

class Map {
    var cols: Int
    var rows: Int
    var nodes : [[Node]]
    init(cols: Int, rows: Int) {
        self.cols = cols
        self.rows = rows
        self.nodes = Array(1 ... cols).map({col in
            Array(1 ... rows).map({row in
                Node(col: col, row: row, letter: randomLetter(), occupied: false)
            })
        })
    }
    
    func allNodes() -> [Node] {
        return self.nodes.reduce([], combine: +)
    }
    
    func neighbours(node:Node) -> [Node] {
        
        var oddRowNeighbours  = [(0, -1), (1, 0), (0, 1), (-1, 1), (-1, 0), (-1, -1)]
        var evenRowNeighbours = [(1, -1), (1, 0), (1, 1), (0 , 1), (-1, 0), (0 , -1)]
        
        var col = node.col - 1
        var row = node.row - 1
        var arr : [Node]! = []
        
        for (x, y) in (even(node.row) ? evenRowNeighbours : oddRowNeighbours) {
            var ci = col + x
            var ri = row + y
            if ci > -1 && ci < self.cols {
                if(ri > -1 && ri < self.rows) {
                    arr.append(self.nodes[ci][ri])
                }
            }
        }
        
        return arr
    }
    
    func neighbours(col: Int, row: Int) -> [Node] {
        return self.neighbours(self.nodes[col - 1][row - 1])
    }
    
    func pickAnEmptyNeighbour(node: Node) -> Node? {
        return pickAnEmptyNeighbour(node.col, row: node.row)
    }
    
    func pickAnEmptyNeighbour(col: Int, row: Int) -> Node? {
        var arr = self.neighbours(col, row: row).filter({node in !node.occupied})
        if(arr.count == 0){
            return nil
        }
        return arr[Int(arc4random_uniform(UInt32(arr.count)))]
    }
    
    func pickAnEmptyNode(tries: Int) -> Node? {
        if(tries == 0) {
            return nil
        }
        
        var c = Int(arc4random_uniform(UInt32(self.cols)))
        var r = Int(arc4random_uniform(UInt32(self.rows)))
        
        var node = self.nodes[c][r]
        if(node.occupied) {
            return pickAnEmptyNode(tries - 1)
        }
        return node
    }
    
    func addWord(word:String) -> Bool {
        return tryAddWord(Array(word), tries: 100)
    }
    
    func tryAddWord(aword:[Character], tries: Int) -> Bool {
        if tries == 0 {
            return false
        }
        
        var root = self.pickAnEmptyNode(tries)
        if(root == nil) {
            return false
        }
        
        if !addWordInNeighbourhood(aword, node: root!) {
            return tryAddWord(aword, tries: tries-1)
        }
        return true
    }
    
    func addWordInNeighbourhood(aword:[Character], node: Node) -> Bool {
        node.setLetter(String(aword[0]))
        
        if(aword.count > 1) {
            var nnode = self.pickAnEmptyNeighbour(node)
            if(nnode == nil) {
                node.clearLetter()
                return false
            }
            if !addWordInNeighbourhood(Array(aword[1 ... aword.count-1]), node: nnode!) {
                node.clearLetter()
                return false
            }
        }
        
        return true
    }
}



class HexagonView : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self._init()

    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self._init()
    }
    
    var hexagonBackgroundColor = UIColor(red: 0, green: 0.8, blue: 1, alpha: 1.0)
    var label : UILabel!
    
    func _init() {
        var frame = self.frame
        self.backgroundColor = UIColor.clearColor()
        var label = UILabel(frame: CGRectMake(0, 0, frame.width, frame.height))
        label.text = "H"
        label.textAlignment = NSTextAlignment.Center
        self.label = label
        self.addSubview(label)
        
        self.addGestureRecognizer(UITapGestureRecognizer(target:self, action:"ontap"))
    }
    
    func ontap() {
        self.hexagonBackgroundColor = UIColor(red: 0.1, green: 1.0, blue: 1, alpha: 1.0)

        self.setNeedsDisplay()
    }
    
    func setLetter(letter: String) {
        self.label.text = letter
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        var bounds = rect //UIScreen.mainScreen().bounds
        var r = rect.width/2
        var tx = { x in x + rect.width/2 }
        var ty = { x in x + rect.width/2 }
        var rad = { x in CGFloat(0.01745329252) * x }
        
        var xs = Array(0 ... 5)
            .map({x in rad(CGFloat(60 * x))})
            .map({x in CGPointMake(r * sin(x), r * cos(x))})
        

        var context = UIGraphicsGetCurrentContext()
        CGContextSetAllowsAntialiasing(context, true)
        
        CGContextSetFillColorWithColor(context, self.hexagonBackgroundColor.CGColor)
        CGContextBeginPath(context)
    
        CGContextMoveToPoint(context, tx(xs[0].x), ty(xs[0].y))
        for p in xs[1 ... xs.count - 1] {
            CGContextAddLineToPoint(context, tx(p.x), ty(p.y))
        }
        CGContextClosePath(context);
        CGContextFillPath(context)

        
        
        r = (rect.width/2) - 6

        xs = Array(0 ... 5)
            .map({x in rad(CGFloat(60 * x))})
            .map({x in CGPointMake(r * sin(x), r * cos(x))})

        CGContextSetRGBStrokeColor(context, 1.0, 1.0, 0.0, 1.0);
        CGContextSetRGBFillColor(context, 0.0, 1.0, 0.0, 0.5);
        CGContextBeginPath(context)
        CGContextMoveToPoint(context, tx(xs[0].x), ty(xs[0].y))
        for p in xs[1 ... xs.count - 1] {
            CGContextAddLineToPoint(context, tx(p.x), ty(p.y))
        }
        CGContextClosePath(context);
        CGContextSetLineWidth(context, 8.0);
        CGContextStrokePath(context);
        
        
        
        CGContextSetRGBFillColor(context, 100, 100, 255, 0.0);
        CGContextFillEllipseInRect(context, CGRectMake(tx(0)-5, ty(0)-5, 10, 10))
        xs.map({p in
            CGContextFillEllipseInRect(context, CGRectMake(tx(p.x)-5, ty(p.y)-5, 10, 10))})
    }
    
}

class TileView : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
        
        var r = CGFloat(100)/2
        var x = CGFloat(sqrt(3.0)) * r / 2
        var rows = 5
        var cols = 4
        
        self.view.bounds = CGRectMake(0, 0, (2 * CGFloat(cols) + 1) * x, 2 * r + (CGFloat(rows) - 1) * 3/2 * r)
        
        var fx = { (col:Int, row:Int) in
            (x - r) +
                CGFloat(!even(row) ? (col - 1) * 2 : 2 * (col - 1) + 1) * x
        }
        
        var fy = { (col:Int, row:Int) in
            1.5 * (CGFloat(row) - 1) * r
        }
        

        var map = Map(cols: cols, rows: rows)
        map.addWord(targetWord)
        map.addWord("fat")
        
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


var view = TileView()
view.view




//class MyScene : SKScene {
//    override func didMoveToView(view: SKView!) {
//    }
//}

