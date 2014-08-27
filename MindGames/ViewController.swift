import Foundation
import UIKit
import SpriteKit

class Tile: SKNode {
    
    var active:Bool = false
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
        roundRectangle.fillColor = Color(hue: 50, saturation: 21, brightness: 94, alpha: 1)
        roundRectangle.strokeColor = SKColor.clearColor()
        addChild(roundRectangle)
        
        label = SKLabelNode()
        label.fontColor = Color(hue: 40, saturation: 24, brightness: 19, alpha: 1)
        label.fontSize = min(self.size.width, self.size.height) * 0.5
        label.position = CGPointMake(CGRectGetMidX(roundRectangle.frame), CGRectGetMidY(roundRectangle.frame))
        label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        addChild(label)
        
    }
    
    func activate() {
        label.fontColor = Color(hue: 28, saturation: 72, brightness: 80, alpha: 1)
        roundRectangle.fillColor = Color(hue: 40, saturation: 23, brightness: 25, alpha: 1)
        active = true
    }
    
    func deactivate() {
        label.fontColor = Color(hue: 40, saturation: 24, brightness: 19, alpha: 1)
        roundRectangle.fillColor = Color(hue: 50, saturation: 21, brightness: 94, alpha: 1)
        active = false
        activationIndex = -1
    }
    
}

class Scene1: SKScene {
    
    var answers:[String] = ["calm"]
    var contentCreated:Bool = false
    var emitter:SKEmitterNode!
    var word:String = "calm"
    
    func activateTileFromPoint(location:CGPoint) {
        for tile in getAllTiles() {
            if tile.containsPoint(location) && !tile.active {
                tile.activate()
                tile.activationIndex = countElements(word)
                word += tile.label.text.lowercaseString
            }
        }
    }
    
    func createContent() {
        self.backgroundColor = SKColor.blackColor()
        createGrid(320, height: 320, rows: 2, columns: 2, characters: ["c", "a", "l", "m"])
    }
    
    func createEmitter(timer:NSTimer) {
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
        emitter.position = CGPointMake(args["x"]!, args["y"]!)
        emitter.xAcceleration = 0
        emitter.yAcceleration = -100
        self.addChild(emitter)
        var delay:Double = Double(args["delay"]!)
        NSTimer.scheduledTimerWithTimeInterval(
            delay,
            target: self,
            selector: "createEmitter:",
            userInfo: [
                "count": args["count"]! - 1.0,
                "delay": args["delay"]!,
                "distance": args["distance"]!,
                "x": args["x"]! + args["distance"]!,
                "y": args["y"]!
            ],
            repeats: false
        )
    }
    
    func createGrid(width:CGFloat, height:CGFloat, rows:Int, columns:Int, characters:[String]) {
        
        var tileWidth = width / CGFloat(rows)
        var tileHeight = height / CGFloat(columns)
        
        for var i = 0; i < rows; i++ {
            for var j = 0; j < columns; j++ {
                var index:Int = (i * rows) + j
                var character = characters[index]
                var tile = Tile(size: CGSizeMake(tileWidth, tileHeight))
                tile.label.text = character.uppercaseString
                tile.position = CGPointMake(CGFloat(j) * tileWidth, CGFloat(i) * tileHeight)
                addChild(tile)
            }
        }
        
    }
    
    func deactivateTiles() {
        for tile in getActiveTiles() {
            tile.deactivate()
        }
    }
    
    func getActiveTiles() -> [Tile] {
        return getAllTiles().filter({
            (tile:Tile) in
            return tile.active
        })
    }
    
    func getAllTiles() -> [Tile] {
        return children.filter {
            (node:AnyObject) in
            if let tile = node as? Tile {
                return true
            }
            return false
        } as [Tile]
    }
    
    func spawnParticles(x:CGFloat, y:CGFloat, count:Int, delay:Double, distance:CGFloat) {
        var userInfo = [
            "count": count,
            "delay": delay,
            "distance": distance,
            "x": x,
            "y": y
        ]
        NSTimer.scheduledTimerWithTimeInterval(0, target: self, selector: "createEmitter:", userInfo: userInfo,repeats: false)
    }
    
    func onWordComposed(valid:Bool) {
        
        if !valid {
            deactivateTiles()
            return
        }
        
        var tiles = getActiveTiles()
        
        for tile:Tile in tiles {
            
            var scale:CGFloat = 0.3
            
            var seconds = (Double(tile.activationIndex) / Double(tiles.count)) * 0.4
            var delay = SKAction.waitForDuration(seconds)
            
            var move = SKAction.moveTo(CGPointMake(CGFloat(tile.activationIndex) * scale * tile.size.width, 0), duration: 0.4)
            move.timingMode = SKActionTimingMode.EaseOut
            
            var scaleAction = SKAction.scaleBy(scale, duration: 0.4)
            scaleAction.timingMode = SKActionTimingMode.EaseOut
            
            var moveAndScale = SKAction.sequence([delay, SKAction.group([move, scaleAction])])
            tile.runAction(moveAndScale, completion: tile.activationIndex == (tiles.count - 1) ? {self.spawnParticles(20, y:20, count:5, delay:0.0, distance:50)} : nil)
            
        }
        
    }
    
    override func didMoveToView(view: SKView!) {
        
        if contentCreated {
            return
        }
        
        self.createContent()
        
    }
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        word = ""
        var touch = touches.allObjects[0] as UITouch
        self.activateTileFromPoint(touch.locationInNode(self))
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        var touch = touches.allObjects[0] as UITouch
        self.activateTileFromPoint(touch.locationInNode(self))
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        onWordComposed(find(answers, word) != nil)
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        
    }
    
}

class Scene2: SKScene {
    
    var locationOnPanBegan:CGPoint!
    var locationOnPanChanged:CGPoint!
    var directionIndicator:SKShapeNode!
    var selectedPlayer:SKSpriteNode!
    var limitedVelocityVector:CGVector!
    
    func createPlayer(image:String) -> SKSpriteNode {
        
        var player = SKSpriteNode(texture: SKTexture(imageNamed: image), size: CGSizeMake(50, 50))
        player.physicsBody = SKPhysicsBody(circleOfRadius: 25)
        player.physicsBody.affectedByGravity = false
        player.physicsBody.angularDamping = 1
        player.physicsBody.friction = 1
        player.physicsBody.linearDamping = 1
        player.physicsBody.mass = 10
        player.physicsBody.restitution = 0.4
        player.name = "player"
        return player
        
    }
    
    func createBall() -> SKSpriteNode {
        
        var ball = SKSpriteNode(texture: SKTexture(imageNamed: "ball"), size: CGSizeMake(18, 18))
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 9)
        ball.physicsBody.affectedByGravity = false
        ball.physicsBody.angularDamping = 1
        ball.physicsBody.linearDamping = 0.5
        ball.physicsBody.mass = 1
        ball.physicsBody.restitution = 0.6
        ball.name = "ball"
        return ball
        
    }
    
    override func didMoveToView(view: SKView!) {
        
        backgroundColor = SKColor.blackColor()
        physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        
        var player = createPlayer("blue")
        player.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame) + 100)
        addChild(player)
        
        player = createPlayer("blue")
        player.position = CGPointMake(CGRectGetMidX(frame) - 100, CGRectGetMidY(frame) + 160)
        addChild(player)
        
        player = createPlayer("blue")
        player.position = CGPointMake(CGRectGetMidX(frame) + 100, CGRectGetMidY(frame) + 160)
        addChild(player)
        
        player = createPlayer("red")
        player.position = CGPointMake(CGRectGetMidX(frame) - 100, CGRectGetMidY(frame) - 100)
        addChild(player)
        
        player = createPlayer("red")
        player.position = CGPointMake(CGRectGetMidX(frame) + 100, CGRectGetMidY(frame) - 100)
        addChild(player)
        
        player = createPlayer("red")
        player.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame) - 160)
        addChild(player)
        
        var ball = createBall()
        ball.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame))
        addChild(ball)
        
        directionIndicator = SKShapeNode()
        directionIndicator.fillColor = SKColor.clearColor()
        directionIndicator.strokeColor = SKColor.whiteColor()
        addChild(directionIndicator)
        
    }
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        
        selectedPlayer = nil
        
        var touch = touches.allObjects[0] as UITouch
        locationOnPanBegan = touch.locationInNode(self)
        
        if let node = nodeAtPoint(locationOnPanBegan) {
            if let sprite = node as? SKSpriteNode {
                if sprite.name == "player" {
                    selectedPlayer = sprite
                }
            }
        }
        
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        
        if selectedPlayer == nil {
            return
        }
        
        var touch = touches.allObjects[0] as UITouch
        locationOnPanChanged = touch.locationInNode(self)
        
        var velocityVector = CGVectorMake(locationOnPanBegan.x - locationOnPanChanged.x, locationOnPanBegan.y - locationOnPanChanged.y)
        var velocityMagnitude = sqrt(pow(velocityVector.dx, 2) + pow(velocityVector.dy, 2))
        var velocityDirection = CGVectorMake(velocityVector.dx / velocityMagnitude, velocityVector.dy / velocityMagnitude)
        var limitedVelocityMagnitude = min(150, velocityMagnitude)
        limitedVelocityVector = CGVectorMake(velocityDirection.dx * limitedVelocityMagnitude, velocityDirection.dy * limitedVelocityMagnitude)
        
        var path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, locationOnPanBegan.x, locationOnPanBegan.y)
        CGPathAddLineToPoint(path, nil, locationOnPanBegan.x + limitedVelocityVector.dx, locationOnPanBegan.y + limitedVelocityVector.dy)
        var circle = CGPathCreateWithEllipseInRect(
            CGRectMake(
                locationOnPanBegan.x - limitedVelocityMagnitude,
                locationOnPanBegan.y - limitedVelocityMagnitude,
                limitedVelocityMagnitude * 2,
                limitedVelocityMagnitude * 2
            ), nil
        )
        CGPathAddPath(path, nil, circle)
        directionIndicator.path = path
        
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        
        if selectedPlayer == nil {
            return
        }
        
        selectedPlayer.physicsBody.velocity = CGVectorMake(limitedVelocityVector.dx * 5, limitedVelocityVector.dy * 5)
        directionIndicator.path = CGPathCreateMutable()
        
    }
    
}


class ViewController:UIViewController {

    var spriteKitScene:Scene2!
    var spriteKitView:SKView!
    var viewport:CGRect!
    
    override func viewDidLoad() {
        
        viewport = UIScreen.mainScreen().bounds
        
        spriteKitView = SKView(frame: viewport)
        spriteKitView.showsFPS = true
        spriteKitView.showsNodeCount = true
        
        spriteKitScene = Scene2(size: CGSizeMake(viewport.size.width, viewport.size.height))
        spriteKitView.presentScene(spriteKitScene)
        
        view.addSubview(spriteKitView)
        
    }
    
}
