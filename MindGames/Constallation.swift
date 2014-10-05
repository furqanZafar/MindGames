import Foundation
import SpriteKit

extension SpinCycle {
    
    class Constallation:SKNode {
        
        var image:String!
        var color:SKColor!
        var scale:CGFloat!
        var direction:CGFloat!
        var orbitalSpeed:CGFloat!
        var radius:CGFloat!
        var numberOfSatellites:Int!
        
        init(image:String, color:SKColor, scale:CGFloat, direction:CGFloat, orbitalSpeed:CGFloat, radius:CGFloat, numberOfSatellites:Int) {
            
            super.init()
            
            self.image = image
            self.color = color
            self.scale = scale
            self.direction = direction
            self.orbitalSpeed = orbitalSpeed
            self.radius = radius
            self.numberOfSatellites = numberOfSatellites
            
            self.name = "constallation"
            
            for i in 0...(numberOfSatellites - 1) {
                var satellite = Satellite(image: image, color: color, scale: scale, direction: direction, orbitalSpeed: orbitalSpeed, radius: radius)
                satellite.angle = CGFloat(i) * 360.0 / CGFloat(numberOfSatellites)
                self.addChild(satellite)
            }
            
        }
        
        func rotate() {
            for satellite in children as [Satellite] {
                satellite.angle = (satellite.angle + satellite.direction * satellite.orbitalSpeed) % 360
            }
        }
        
        required init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
}