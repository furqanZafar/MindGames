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
            
            let label = UILabel(frame: CGRectMake(20, 60, 280, 45))
            label.textColor = UIColor.blackColor()
            let (text, result) = makeFormula(0)
            label.text = "\(text) = ?"
            view.addSubview(label)
            
            button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "ontap"))
            
        }
        
        func ontap() {
            UIAlertView(title: "Finally!", message: "You can do it", delegate: nil, cancelButtonTitle: "OK!").show()
            
        }
        
        func makeFormula(level: Int) -> (String, Int) {
            let binaryOperations : [(String, (Int, Int) -> Int)] = [("+", +), ("*", *)]
            let unaryRightOperations : [(String, Int -> Int)] = [("!", factorial)]
            let leaves = 5
            
            // Int(arc4random_uniform(5))
            // binaryOperations[Int(arc4random_uniform(UInt32(binaryOperations.count)))]
            
            var root = makeTree(leaves) //Tree.Node(Tree.Node(Tree.Leaf(5), Tree.Leaf(3), "*", *), Tree.Leaf(19), "+", +)
            return (root.toString(), root.toResult())
    
        }
        
        func makeTree(leaves: Int) -> Tree {
            let binaryOperations : [(String, (Int, Int) -> Int)] = [("+", +), ("*", *)]
            let (op, f) = binaryOperations[Int(arc4random_uniform(UInt32(binaryOperations.count)))]
            let a  = Int(arc4random_uniform(5))
            let b = Int(arc4random_uniform(5))
            if leaves == 1 { return Tree.Leaf(a) }
            if leaves == 2 {
                return Tree.Node(Tree.Leaf(a), Tree.Leaf(b), op, f)
            }
            if arc4random_uniform(10) > 5 {
                return Tree.Node(makeTree(leaves-1), Tree.Leaf(b), op, f)
            } else {
                return Tree.Node(Tree.Leaf(a), makeTree(leaves-1), op, f)
            }
            
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
                    case .Node(let left, let right, let _, let f):
                        return f(left.toResult(), right.toResult())
                }
            }
            
            func toString() -> String {
                switch self {
                    case .Leaf(let i): return "\(i)"
                    case .Node(let left, let right, let op, let _):
                        let l = (left.isNode() ? "(" : "") + (left.toString()) + (left.isNode() ? ")" : "")
                        let r = (right.isNode() ? "(" : "") + (right.toString()) + (right.isNode() ? ")" : "")
                        return l + " \(op) " + r
                }
            }
            
            func isNode() -> Bool {
                switch self {
                    case .Node(_, _, let op, _): return op != "+"
                    default: return false
                }
            }
        }
    }
}

protocol TreeLike {
    func toString() -> String
    func toResult() -> Int
    func isNode() -> Bool
}