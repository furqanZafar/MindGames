import SpriteKit


extension WordBrain {

    class Scene: SKScene {
        
        var answers:[String] = ["calm"]
        var contentCreated:Bool = false
        var emitter:SKEmitterNode!
        var word:String = "calm"
        
        func activateTileFromPoint(location:CGPoint) -> String? {
            for tile in getAllTiles() {
                if tile.containsPoint(location) && !tile.active {
                    var letter = tile.activate()
                    tile.activationIndex = countElements(word)
                    return letter
                }
            }
            return nil
        }
        
        func createContent() {
            self.backgroundColor = SKColor.blackColor()
            createGrid(280, height: 280, rows: 2, columns: 2, characters: ["c", "a", "l", "m"])
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
            
            var xOffset = (self.frame.width - width) / 2
            var yOffset = (self.frame.size.height - height) / 2
            
            for var i = 0; i < rows; i++ {
                for var j = 0; j < columns; j++ {
                    var index:Int = (i * rows) + j
                    var character = characters[index]
                    var tile = Tile(size: CGSizeMake(tileWidth, tileHeight))
                    tile.label.text = character.uppercaseString
                    tile.position = CGPointMake(xOffset + CGFloat(j) * tileWidth, yOffset + CGFloat(i) * tileHeight)
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
            var xOffset = (self.frame.size.width - CGFloat(tiles.count) * tiles[0].size.width * 0.3) / 2
            var yOffset:CGFloat = 64
            
            for tile:Tile in tiles {
                
                var scale:CGFloat = 0.3
                
                var seconds = (Double(tile.activationIndex) / Double(tiles.count)) * 0.4
                var delay = SKAction.waitForDuration(seconds)
                
                var move = SKAction.moveTo(CGPointMake(xOffset + CGFloat(tile.activationIndex) * scale * tile.size.width, yOffset), duration: 0.4)
                move.timingMode = SKActionTimingMode.EaseOut
                
                var scaleAction = SKAction.scaleBy(scale, duration: 0.4)
                scaleAction.timingMode = SKActionTimingMode.EaseOut
                
                var moveAndScale = SKAction.sequence([delay, SKAction.group([move, scaleAction])])
                tile.runAction(moveAndScale, completion: tile.activationIndex == (tiles.count - 1) ? {self.spawnParticles(xOffset + 20, y:yOffset + 20, count:4, delay:0.0, distance:45)} : nil)
                
            }
            
        }
        
        override func didMoveToView(view: SKView) {
            
            if contentCreated {
                return
            }
            
            self.createContent()
            
        }
        
        override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
            word = ""
            var touch = touches.allObjects[0] as UITouch
            if let letter = self.activateTileFromPoint(touch.locationInNode(self)) {
                word += letter
            }
        }
        
        override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
            var touch = touches.allObjects[0] as UITouch
            if let letter = self.activateTileFromPoint(touch.locationInNode(self)) {
                word += letter
            }
        }
        
        override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
            println("word = \(word)")
            onWordComposed(find(answers, word.lowercaseString) != nil)
        }
        
        override func touchesCancelled(touches: NSSet, withEvent event: UIEvent) {
            
        }
        
    }
    
}