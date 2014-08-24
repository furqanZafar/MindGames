import Foundation
import UIKit
import SpriteKit

class HelloScene: SKScene {
    
    var contentCreated:Bool = false
    var emitter:SKEmitterNode!
    
    override func didMoveToView(view: SKView!) {
        
        if contentCreated {
            return
        }
        
        self.createContent()
        
    }
    
    func createContent() {
        
        self.backgroundColor = SKColor.blackColor()
        
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "spawnParticles:", userInfo: ["xOffset":CGFloat(-120), "count": CGFloat(5)], repeats: false)
        
        // var sprite = SKSpriteNode(color: SKColor.redColor(), size: CGSizeMake(88, 88))
        // sprite.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        // self.addChild(sprite)
        
    }
    
    
    func spawnParticles(timer:NSTimer) {
        var args:Dictionary<String, CGFloat> = timer.userInfo as Dictionary<String,CGFloat>
        if args["count"]! == 0 {
            return
        }
        emitter = SKEmitterNode()
        emitter.emissionAngle = 0
        emitter.emissionAngleRange = CGFloat(M_PI) * 2
        emitter.numParticlesToEmit = 20
        emitter.particleAlpha = 0.8
        emitter.particleAlphaRange = 0
        emitter.particleAlphaSpeed = -0.4
        emitter.particleBirthRate = 60
        emitter.particleBlendMode = SKBlendMode.Add
        emitter.particleColor = SKColor.whiteColor()
        emitter.particleColorBlendFactor = 0.5
        emitter.particleColorBlendFactorRange = 0.3
        emitter.particleColorBlendFactorSpeed = 0.2
        emitter.particleColorSequence = SKKeyframeSequence(
            keyframeValues: [SKColor(red: 1, green: 0, blue: 1, alpha: 1), SKColor(red: 1, green: 0, blue: 0, alpha: 1)],
            times: [0.0, 1.0]
        )
        emitter.particleLifetime = 2
        emitter.particlePosition = CGPointMake(0, 0)
        emitter.particleRotation = 0
        emitter.particleRotationRange = CGFloat(M_PI) * 2
        emitter.particleRotationSpeed = CGFloat(M_PI) / 12
        emitter.particleScale = 0.3
        emitter.particleScaleRange = 0.1
        emitter.particleScaleSpeed = 0.1
        emitter.particleSpeed = 50
        emitter.particleSpeedRange = 100
        emitter.particleTexture = SKTexture(imageNamed: "star")
        emitter.position = CGPointMake(args["xOffset"]! + CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        emitter.xAcceleration = 0
        emitter.yAcceleration = -100
        self.addChild(emitter)
        NSTimer.scheduledTimerWithTimeInterval(0, target: self, selector: "spawnParticles:", userInfo: ["xOffset": args["xOffset"]! + 48, "count": args["count"]! - 1.0], repeats: false)
    }
    
}

class ViewController:UIViewController {

    var spriteKitScene:HelloScene!
    var spriteKitView:SKView!
    var viewport:CGRect!
    
    override func viewDidLoad() {
        
        viewport = UIScreen.mainScreen().bounds
        
        spriteKitView = SKView(frame: viewport)
        spriteKitView.showsFPS = true
        spriteKitView.showsNodeCount = true
        
        spriteKitScene = HelloScene(size: CGSizeMake(viewport.size.width, viewport.size.height))
        spriteKitView.presentScene(spriteKitScene)
        
        view.addSubview(spriteKitView)
        
    }
    
}