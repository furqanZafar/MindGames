import Foundation
import UIKit


class GTWHexagonView : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self._init()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self._init()
    }
    
    var hexagonBackgroundColor = UIColor(red: 0, green: 0.8, blue: 1, alpha: 1.0)
    var label : UILabel!
    
    func _init() {
        var frame = self.frame
        self.backgroundColor = UIColor.clearColor()
        var label = UILabel(frame: CGRectMake(0, 0, frame.width, frame.height))
        label.text = "H"
        label.textAlignment = NSTextAlignment.Center
        self.label = label
        self.addSubview(label)
        
        self.addGestureRecognizer(UITapGestureRecognizer(target:self, action:"ontap"))
    }
    
    func ontap() {
        self.hexagonBackgroundColor = UIColor(red: 0.1, green: 1.0, blue: 1, alpha: 1.0)
        
        self.setNeedsDisplay()
    }
    
    func setLetter(letter: String) {
        self.label.text = letter
    }
    
    // \/ \/ \/ highlight \/ \/ \/
    var highlighted = false
    var highlightOriginalHexagonBackgroundColor : UIColor!
    func highlight() {
        if self.highlighted {
            return
        }
        self.highlighted = true
        self.highlightOriginalHexagonBackgroundColor = self.hexagonBackgroundColor
        self.hexagonBackgroundColor = UIColor.orangeColor()
        self.setNeedsDisplay()
    }
    func deHighlight() {
        if !self.highlighted {
            return
        }
        self.hexagonBackgroundColor = self.highlightOriginalHexagonBackgroundColor
        self.setNeedsDisplay()
        self.highlighted = false
    }
    
    func preciseHitTest(point : CGPoint) -> Bool {
        var r = self.frame.width
        var x = point.x - r/2
        var y = point.y - r/2
        
        var rr = 0.75 * r
        
        return (x >= -1 * rr && x <= rr && y >= -1 * rr && y <= rr)
    }
    // /\ /\ /\ highlight /\ /\ /\
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        var bounds = rect //UIScreen.mainScreen().bounds
        var r = rect.width/2
        var tx = { x in x + rect.width/2 }
        var ty = { x in x + rect.width/2 }
        var rad = { x in CGFloat(0.01745329252) * x }
        
        var xs = Array(0 ... 5)
            .map({x in rad(CGFloat(60 * x))})
            .map({x in CGPointMake(r * sin(x), r * cos(x))})
        
        
        var context = UIGraphicsGetCurrentContext()
        CGContextSetAllowsAntialiasing(context, true)
        
        CGContextSetFillColorWithColor(context, self.hexagonBackgroundColor.CGColor)
        CGContextBeginPath(context)
        
        CGContextMoveToPoint(context, tx(xs[0].x), ty(xs[0].y))
        for p in xs[1 ... xs.count - 1] {
            CGContextAddLineToPoint(context, tx(p.x), ty(p.y))
        }
        CGContextClosePath(context);
        CGContextFillPath(context)
        
        
        
        r = (rect.width/2) - 6
        
        xs = Array(0 ... 5)
            .map({x in rad(CGFloat(60 * x))})
            .map({x in CGPointMake(r * sin(x), r * cos(x))})
        
        CGContextSetRGBStrokeColor(context, 1.0, 1.0, 0.0, 1.0);
        CGContextSetRGBFillColor(context, 0.0, 1.0, 0.0, 0.5);
        CGContextBeginPath(context)
        CGContextMoveToPoint(context, tx(xs[0].x), ty(xs[0].y))
        for p in xs[1 ... xs.count - 1] {
            CGContextAddLineToPoint(context, tx(p.x), ty(p.y))
        }
        CGContextClosePath(context);
        CGContextSetLineWidth(context, 8.0);
        CGContextStrokePath(context);
        
        
        
        CGContextSetRGBFillColor(context, 100, 100, 255, 0.0);
        CGContextFillEllipseInRect(context, CGRectMake(tx(0)-5, ty(0)-5, 10, 10))
        xs.map({p in
            CGContextFillEllipseInRect(context, CGRectMake(tx(p.x)-5, ty(p.y)-5, 10, 10))})
    }
    
}
