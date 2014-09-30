import SpriteKit

extension WordBrain {

    class Tile: SKNode {
        
        var active:Bool = false
        var activeBGColor:Color = Color(hue: 40, saturation: 23, brightness: 25, alpha: 1)
        var activeTextColor:Color = Color(hue: 28, saturation: 72, brightness: 80, alpha: 1)
        var inactiveBGColor:Color = Color(hue: 50, saturation: 21, brightness: 94, alpha: 1)
        var inactiveTextColor:Color = Color(hue: 40, saturation: 24, brightness: 19, alpha: 1)
        var activationIndex:Int = -1
        var size:CGSize!
        var roundRectangle:SKShapeNode!
        var label:SKLabelNode!
        
        required init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        init(size:CGSize) {
            
            super.init()
            
            self.size = size
            
            roundRectangle = SKShapeNode()
            roundRectangle.path = CGPathCreateWithRoundedRect(CGRectMake(0, 0, self.size.width, self.size.height), 24, 24, nil)
            roundRectangle.fillColor = inactiveBGColor
            roundRectangle.strokeColor = SKColor.clearColor()
            addChild(roundRectangle)
            
            label = SKLabelNode()
            label.fontColor = inactiveTextColor
            label.fontSize = min(self.size.width, self.size.height) * 0.5
            label.position = CGPointMake(CGRectGetMidX(roundRectangle.frame), CGRectGetMidY(roundRectangle.frame))
            label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
            addChild(label)
            
        }
        
        func activate() -> String {
            label.fontColor = activeTextColor
            roundRectangle.fillColor = activeBGColor
            active = true
            return label.text
        }
        
        func deactivate() {
            label.fontColor = inactiveTextColor
            roundRectangle.fillColor = inactiveBGColor
            active = false
            activationIndex = -1
        }
        
    }

}
