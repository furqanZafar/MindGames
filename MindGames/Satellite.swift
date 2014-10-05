import Foundation
import SpriteKit

class Satellite:SKSpriteNode {
    
    var _angle:CGFloat = 0
    var angle:CGFloat {
        get {
            return _angle * 180 / CGFloat(M_PI)
        }
        set (newAngle) {
            _angle = newAngle / CGFloat(180) * CGFloat(M_PI)
            position.x = radius * cos(_angle)
            position.y = radius * sin(_angle)
        }
    }
    var direction:CGFloat!
    var orbitalSpeed:CGFloat!
    var radius:CGFloat!
    
    init(image:String, color:SKColor, scale:CGFloat, direction:CGFloat, orbitalSpeed:CGFloat, radius:CGFloat) {
        super.init(texture: SKTexture(imageNamed: image), color: color, size: CGSizeMake(88, 88))
        blendMode = SKBlendMode.Alpha
        colorBlendFactor = 1
        self.direction = direction
        self.orbitalSpeed = orbitalSpeed
        self.radius = radius
        self.xScale = scale
        self.yScale = scale
        name = "satellite"
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
