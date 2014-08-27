import Foundation
import UIKit
import SpriteKit

class GridModel: NSObject {
    
    var rows:Int!
    var columns:Int!
    var characters:[String]!
    var answers:[String]!
    
}

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

class Grid: SKNode {
    
    var model:GridModel!
    var width:CGFloat!
    var height:CGFloat!
    var word:String = ""
    
    init(width:CGFloat, height:CGFloat) {
        super.init()
        self.width = width
        self.height = height
    }

    func setCenter(x:CGFloat, y:CGFloat) {
        self.position = CGPointMake(x - self.width / 2, y - self.height / 2)
    }
    
    func setModel(model:GridModel) {
        
        self.model = model
        
        var tileWidth = self.width / CGFloat(model.rows)
        var tileHeight = self.height / CGFloat(model.columns)
        
        for var i = 0; i < model.rows; i++ {
            for var j = 0; j < model.columns; j++ {
                var index:Int = (i * model.rows) + j
                var character = model.characters[index]
                var tile = Tile(size: CGSizeMake(tileWidth, tileHeight))
                tile.label.text = character.uppercaseString
                tile.position = CGPointMake(CGFloat(j) * tileWidth, CGFloat(i) * tileHeight)
                self.addChild(tile)
            }
        }
        
    }
    
    func activateTileFromPoint(location:CGPoint) {
        for var i:Int = 0; i < self.children.count; i++ {
            var tile = self.children[i] as Tile
            if tile.containsPoint(location) && !tile.active {
                tile.activate()
                tile.activationIndex = countElements(word)
                word += tile.label.text.lowercaseString
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        var valid = find(model.answers, word) != nil
        var notification = NSNotification(name: "wordComposed", object: nil, userInfo: ["valid": valid, "word": word])
        NSNotificationCenter.defaultCenter().postNotification(notification)
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        
    }
    
    func getActiveTiles() -> [Tile] {
        return self.children.filter { (o:AnyObject) -> Bool in
            if let tile = o as? Tile {
                return tile.active
            }
            return false
        } as [Tile]
    }
    
    func deactivateTiles() {
        for tile:Tile in self.getActiveTiles() {
            tile.deactivate()
        }
    }
    
}

class HelloScene: SKScene {
    
    var contentCreated:Bool = false
    var emitter:SKEmitterNode!
    var grid:Grid!
    
    override func didMoveToView(view: SKView!) {
        
        if contentCreated {
            return
        }
        
        self.createContent()
        
    }
    
    func createContent() {
        
        self.backgroundColor = SKColor.blackColor()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onWordComposed:", name: "wordComposed", object: nil)
        
        var gridModel = GridModel()
        gridModel.rows = 3
        gridModel.columns = 3
        gridModel.characters = ["t", "l", "a", "k", "s", "b", "c", "d", "e"]
        gridModel.answers = ["talk", "klat"]
        
        grid = Grid(width: 320, height: 320)
        grid.setModel(gridModel)
        grid.setCenter(CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        grid.userInteractionEnabled = true
        
        self.addChild(grid)
        
    }
    
    func spawnParticles() {
        var userInfo = ["x": 0, "y": 145, "xOffset": 30, "count": 4, "distance": 44, "delay": 0.1]
        NSTimer.scheduledTimerWithTimeInterval(0, target: self, selector: "createEmitter:", userInfo: userInfo,repeats: false)
    }
    
    func onWordComposed(notification:NSNotification) {
        
        var args = notification.userInfo as Dictionary<String, AnyObject>
        var word = args["word"]! as String
        var valid = args["valid"]! as Bool
        
        if !valid {
            self.grid.deactivateTiles()
            return
        }
        
        var tiles = self.grid.getActiveTiles()
        
        for tile:Tile in tiles {
            
            var scale:CGFloat = 0.3
            
            var seconds = (Double(tile.activationIndex) / Double(tiles.count)) * 0.4
            var delay = SKAction.waitForDuration(seconds)
            
            var move = SKAction.moveTo(CGPointMake(CGFloat(tile.activationIndex) * scale * tile.size.width, 0), duration: 0.4)
            move.timingMode = SKActionTimingMode.EaseOut
            
            var scaleAction = SKAction.scaleBy(scale, duration: 0.4)
            scaleAction.timingMode = SKActionTimingMode.EaseOut
            
            var moveAndScale = SKAction.sequence([delay, SKAction.group([move, scaleAction])])
            tile.runAction(moveAndScale, completion: tile.activationIndex == (tiles.count - 1) ? spawnParticles : nil)
            
        }
        
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
        emitter.position = CGPointMake(args["x"]! + args["xOffset"]!, args["y"]!)
        emitter.xAcceleration = 0
        emitter.yAcceleration = -100
        self.addChild(emitter)
        var delay:Double = Double(args["delay"]!)
        NSTimer.scheduledTimerWithTimeInterval(
            delay,
            target: self,
            selector: "createEmitter:",
            userInfo: [
                "delay": args["delay"]!,
                "x": args["x"]!,
                "y": args["y"]!,
                "xOffset": args["xOffset"]! + args["distance"]!,
                "distance": args["distance"]!,
                "count": args["count"]! - 1.0
            ],
            repeats: false
        )
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