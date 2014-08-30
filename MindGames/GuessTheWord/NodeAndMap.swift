import Foundation

var even = { x in x%2 == 0 }
var odd = { x in !even(x) }

var letters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")

func randomLetter() -> String {
    return "" + String(letters[Int(arc4random_uniform(UInt32(letters.count)))])
}


class GTWNode {
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

class GTWMap {
    var cols: Int
    var rows: Int
    var nodes : [[GTWNode]]
    init(cols: Int, rows: Int) {
        self.cols = cols
        self.rows = rows
        self.nodes = Array(1 ... cols).map({col in
            Array(1 ... rows).map({row in
                GTWNode(col: col, row: row, letter: randomLetter(), occupied: false)
            })
        })
    }
    
    func allNodes() -> [GTWNode] {
        return self.nodes.reduce([], combine: +)
    }
    
    func neighbours(node:GTWNode) -> [GTWNode] {
        
        var oddRowNeighbours  = [(0, -1), (1, 0), (0, 1), (-1, 1), (-1, 0), (-1, -1)]
        var evenRowNeighbours = [(1, -1), (1, 0), (1, 1), (0 , 1), (-1, 0), (0 , -1)]
        
        var col = node.col - 1
        var row = node.row - 1
        var arr : [GTWNode]! = []
        
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
    
    func neighbours(col: Int, row: Int) -> [GTWNode] {
        return self.neighbours(self.nodes[col - 1][row - 1])
    }
    
    func pickAnEmptyNeighbour(node: GTWNode) -> GTWNode? {
        return pickAnEmptyNeighbour(node.col, row: node.row)
    }
    
    func pickAnEmptyNeighbour(col: Int, row: Int) -> GTWNode? {
        var arr = self.neighbours(col, row: row).filter({node in !node.occupied})
        if(arr.count == 0){
            return nil
        }
        return arr[Int(arc4random_uniform(UInt32(arr.count)))]
    }
    
    func pickAnEmptyNode(tries: Int) -> GTWNode? {
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
    
    func addWordInNeighbourhood(aword:[Character], node: GTWNode) -> Bool {
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
