import Foundation
import SpriteKit

extension SpinCycle {
    
    class Question {
        
        var answer:Bool = false
        var predicate:(Constallation, Constallation) -> Bool!
        var text: String!
        
        init (text: String!, predicate: (Constallation, Constallation) -> Bool) {
            self.text = text
            self.predicate = predicate
        }
        
    }
    
}
