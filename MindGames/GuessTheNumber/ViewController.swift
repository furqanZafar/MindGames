import Foundation
import UIKit

struct GuessTheNumber {

    class ViewController: UIViewController {
        override func viewDidLoad() {
            
            let button = UIButton(frame: CGRectMake(22, 10, 200, 42))
            button.backgroundColor = UIColor.redColor()
            button.titleLabel.textColor = UIColor.whiteColor()
            button.setTitle("hello", forState: UIControlState.Normal)
            view.addSubview(button)
            button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "ontap"))

            
            let refreshButton = UIButton(frame: CGRectMake(242, 10, 40, 42))
            refreshButton.backgroundColor = UIColor.redColor()
            refreshButton.titleLabel.textColor = UIColor.whiteColor()
            refreshButton.setTitle("(R)", forState: UIControlState.Normal)
            view.addSubview(refreshButton)
            refreshButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onRefresh"))
            
            
            
            let label = UILabel(frame: CGRectMake(20, 60, 280, 45))
            label.textColor = UIColor.blackColor()
            let (text, result) = makeFormula(0)
            self.result = result
            self.label = label
            label.text = "\(text) = ?"
            view.addSubview(label)
            
        }
        
        var result: Int = 0
        var label: UILabel!
        
        func ontap() {
            UIAlertView(title: "=", message: "\(self.result)", delegate: nil, cancelButtonTitle: "OK!").show()
        }
        
        func onRefresh() {
            let (text, result) = makeFormula(0)
            label.text = "\(text) = ?"
            self.result = result
        }
        
        func makeFormula(level: Int) -> (String, Int) {
            let binaryOperations : [(String, (Int, Int) -> Int)] = [("+", +), ("-", -), ("*", *)]
            let unaryRightOperations : [(String, Int -> Int)] = [("!", factorial)]
            let leaves = 6
            
            // Int(arc4random_uniform(5))
            // binaryOperations[Int(arc4random_uniform(UInt32(binaryOperations.count)))]
            
            var root = makeTree(leaves) //Tree.Node(Tree.Node(Tree.Leaf(5), Tree.Leaf(3), "*", *), Tree.Leaf(19), "+", +)
            return (root.toString(), root.toResult())
    
        }
        
        func makeTree(leaves: Int) -> Tree {
            let binaryOperations : [(String, (Int, Int) -> Int)] = [("+", +), ("-", -), ("*", *)]
            let (op, f) = binaryOperations[Int(arc4random_uniform(UInt32(binaryOperations.count)))]
            let a  = Int(arc4random_uniform(100))
            let b = Int(arc4random_uniform(100))
            if leaves == 1 { return Tree.Leaf(a) }
            if leaves == 2 {
                return Tree.Node(Tree.Leaf(a), Tree.Leaf(b), op, f)
            }
            if leaves == 3 {
                if arc4random_uniform(10) > 5 {
                    return Tree.Node(makeTree(leaves-1), Tree.Leaf(b), op, f)
                } else {
                    return Tree.Node(Tree.Leaf(a), makeTree(leaves-1), op, f)
                }
            }
            let left = Int(floor(Double(leaves)/2.0))
            let right = Int(ceil(Double(leaves)/2.0))
            return Tree.Node(makeTree(left), makeTree(right), op, f)
        }
        
        func factorial(n: Int) -> Int {
            if n == 0 { return 1 }
            return n * factorial(n - 1)
        }
        
        enum Tree: TreeLike {
            case Leaf(Int)
            case Node(TreeLike, TreeLike, String, (Int, Int) -> Int)
            
            func toResult() -> Int {
                switch self {
                    case .Leaf(let i): return i
                    case .Node(let left, let right, _, let f):
                        return f(left.toResult(), right.toResult())
                }
            }
            
            func toString() -> String {
                switch self {
                    case .Leaf(let i): return "\(i)"
                    case .Node(let left, let right, let op, _):
                        let lp = left.precedence()
                        let rp = right.precedence()
                        let sp = self.precedence()
                        var r = right.toString()
                        var l = left.toString()
                        if sp > lp {
                            l = "(  \(l) )"
                        }
                        if sp > rp || (self.requireParanthesis() && right.isNode()) {
                            r = "( \(r) )"
                        }
                        return l + " \(op) " + r
                }
            }
            
            func isNode() -> Bool {
                switch self {
                    case .Node(_, _, let op, _): return true
                    default: return false
                }
            }
            
            func requireParanthesis() -> Bool {
                switch self {
                case .Node(_, _, let op, _):
                    switch op {
                        case "-": return true
                        default: return false
                    }
                case .Leaf(_): return false
                }
            }
            
            func precedence() -> Int {
                switch self {
                    case .Node(_, _, let op, _):
                        switch op {
                            case "+": return 1
                            case "-": return 1
                            case "*": return 2
                            default: fatalError("!!!")
                        }
                    case .Leaf(_): return 100
                }
            }
        }
    }
}

protocol TreeLike {
    func toString() -> String
    func toResult() -> Int
    func isNode() -> Bool
    func precedence() -> Int
    func requireParanthesis() -> Bool
}