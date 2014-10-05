import SpriteKit
import AudioToolbox

extension SpinCycle {
    
    class Scene: SKScene {
        
        var currentQuestion:Question!
        var questions:[Question]!
        var memorized:Bool = false
        var viewport:CGRect = UIScreen.mainScreen().bounds

        override func didMoveToView(view: SKView) {
            
            backgroundColor = SKColor.blackColor()
            questions = [
                Question(text: "Shape is the same?") { $0.image == $1.image},
                Question(text: "Shape has changed?") { $0.image != $1.image},
                Question(text: "Color is the same?") { $0.color == $1.color},
                Question(text: "Color has changed?") { $0.color != $1.color},
                Question(text: "Size is the same?") { $0.scale == $1.scale},
                Question(text: "Size has changed?") { $0.scale != $1.scale},
                Question(text: "Direction is the same?") { $0.direction == $1.direction},
                Question(text: "Direction has changed?") { $0.direction != $1.direction},
                Question(text: "Speed is the same?") { $0.orbitalSpeed == $1.orbitalSpeed},
                Question(text: "Speed has changed?") { $0.orbitalSpeed != $1.orbitalSpeed},
                Question(text: "Number is the same?") { $0.numberOfSatellites == $1.numberOfSatellites},
                Question(text: "Number has changed?") { $0.numberOfSatellites != $1.numberOfSatellites}
            ]
            
            var constallation = createConstallation()
            constallation.position = CGPointMake(CGRectGetMidX(viewport), CGRectGetMidY(viewport))
            addChild(constallation)
            
        }
        
        func nextQuestion() {
            
            var previousConstallation = childNodeWithName("constallation") as Constallation
            
            var currentConstallation = createConstallation()
            currentConstallation.position = previousConstallation.position
            addChild(currentConstallation)
            
            currentQuestion = pick(questions) as Question
            currentQuestion.answer = currentQuestion.predicate(previousConstallation, currentConstallation)
            
            var questionText = childNodeWithName("questionText") as SKLabelNode
            questionText.text = currentQuestion.text
            
            previousConstallation.runAction(SKAction.sequence([SKAction.fadeAlphaTo(0, duration: 0.2), SKAction.removeFromParent()]))
            currentConstallation.runAction(SKAction.fadeInWithDuration(0.2))
            
        }
        
        func createConstallation() -> Constallation {
            return Constallation(
                image: pick(["hexagon", "circle", "square"]) as String,
                color: pick([SKColor.redColor(), SKColor.greenColor(), SKColor(hue: 208 / 360, saturation: 0.82, brightness: 1, alpha: 1), SKColor.yellowColor()]) as SKColor,
                scale: pick([0.8, 0.7, 0.6]) as CGFloat,
                direction: pick([1, -1]) as CGFloat,
                orbitalSpeed: pick([1, 2, 3]) as CGFloat,
                radius: pick([80, 100, 120]) as CGFloat,
                numberOfSatellites: pick([4, 5, 6]) as Int
            )
        }
        
        
        func pick (items:[AnyObject]) -> AnyObject {
            var index:Int = Int(arc4random_uniform(UInt32(items.count)))
            return items[index]
        }
        
        override func didFinishUpdate() {
            for child in children {
                if child.name != "constallation" {
                    continue
                }
                var constallation = child as Constallation
                constallation.rotate()
            }
        }
        
        override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
            
            if memorized {
                
                var node = nodeAtPoint((touches.anyObject() as UITouch).locationInNode(self))
                
                if let range = node.name?.rangeOfString("Button", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil) {
                    if (node.name == "trueButton" && currentQuestion.answer) || (node.name == "falseButton" && !currentQuestion.answer) {
                    }
                    else {
                        AudioServicesPlaySystemSound(1352)
                    }
                    nextQuestion()
                }
                
                return
                
            }
            
            memorized = true
            
            var trueButton = SKSpriteNode(color: UIColor.greenColor(), size: CGSizeMake(viewport.size.width / 2 - 1, 44))
            trueButton.name = "trueButton"
            trueButton.position = CGPointMake(trueButton.size.width / 2, trueButton.size.height / 2)
            addChild(trueButton)
            
            
            var falseButton = SKSpriteNode(color: UIColor.redColor(), size: CGSizeMake(viewport.size.width / 2 - 1, 44))
            falseButton.name = "falseButton"
            falseButton.position = CGPointMake(CGRectGetMidX(viewport) + 1 + trueButton.size.width / 2, trueButton.size.height / 2)
            addChild(falseButton)
            
            var questionText = SKLabelNode()
            questionText.name = "questionText"
            questionText.fontName = "HelveticaNeue-Thin"
            questionText.fontSize = 20
            questionText.position = CGPointMake(CGRectGetMidX(viewport), trueButton.size.height + 20)
            addChild(questionText)
            
            nextQuestion()
            
        }
        
    }
    
}