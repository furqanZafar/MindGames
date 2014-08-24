// Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

class Color: UIColor {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        super.init(hue: hue / 360.0, saturation: saturation / 100.0, brightness: brightness / 100.0, alpha: alpha)
    }
    
}

