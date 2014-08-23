import UIKit

class Clock: UIView {
    
    var centerPoint:CGPoint!
    var color:(CGFloat, CGFloat, CGFloat)!
    var link:DisplayLink!
    var maxAlpha:CGFloat!
    var minAlpha:CGFloat!
    var progress:CGFloat = 0
    var radius:CGFloat!
    
    init(frame: CGRect, color:(CGFloat, CGFloat, CGFloat), minAlpha:CGFloat, maxAlpha:CGFloat) {
        super.init(frame: frame)
        self.centerPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
        self.color = color
        self.maxAlpha = maxAlpha
        self.minAlpha = minAlpha
        self.radius = self.bounds.size.width / 2
        self.backgroundColor = UIColor.clearColor()
        self.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(-1, 1), -CGFloat(M_PI) / 2.0)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func getColor(color:(CGFloat, CGFloat, CGFloat), alpha:CGFloat) -> CGColorRef {
        return UIColor(red: color.0, green: color.1, blue: color.2, alpha: alpha).CGColor
    }
    
    override func drawRect(rect: CGRect) {
        
        super.drawRect(rect)
        
        var context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColor(context, CGColorGetComponents(self.getColor(color, alpha: minAlpha)))
        CGContextAddEllipseInRect(context, self.bounds)
        CGContextFillPath(context)
        
        CGContextSetFillColor(context, CGColorGetComponents(self.getColor(color, alpha: maxAlpha)))
        CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, 0, CGFloat(M_PI) * 2.0 * (1 - progress), 0)
        CGContextAddLineToPoint(context, centerPoint.x, centerPoint.y)
        CGContextFillPath(context)
        
    }
    
    func animateWithDuration(duration:Double)  {
        link = DisplayLink(
            duration: duration,
            onChange: {
                (link:DisplayLink) in
                self.progress = CGFloat(link.p)
                self.setNeedsDisplay()
            },
            onComplete: {
                (link:DisplayLink) in
                
            }
        )        
    }
    
}
