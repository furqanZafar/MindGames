import UIKit

extension ColorOfDeception {

    class Tile: UIView {
        
        var defective:Bool = false
        var label:UILabel!
        var shadow:UIImageView!
        
        required init(coder aDecoder: NSCoder) {
            return super.init(coder: aDecoder)
        }
        
        override init(frame: CGRect) {
            
            super.init(frame: frame)
            
            self.layer.cornerRadius = 6
            self.clipsToBounds = true
            
            shadow = UIImageView(frame: self.bounds)
            shadow.alpha = 0.3
            shadow.contentMode = UIViewContentMode.ScaleAspectFit
            shadow.image = UIImage(named: "innerShadow")
            self.addSubview(shadow)
            
            label = UILabel(frame: self.bounds)
            label.adjustsFontSizeToFitWidth = true
            label.textAlignment = NSTextAlignment.Center
            label.font = UIFont(name: "HelveticaNeue", size: 24)
            self.addSubview(label)
            
        }
        
        func setText(text:String) {
            label.text = text
            label.textColor = backgroundColor == UIColor.whiteColor() ? UIColor.blackColor() : UIColor.whiteColor()
        }
        
        func blink(duration:Double, speed:Double, accumalatedTime:Double, hide:Bool) {
            UIView.animateWithDuration(
                speed,
                animations: {
                    self.alpha = hide ? 0 : 1
                },
                completion: {
                    (finish: Bool) in
                    if accumalatedTime + speed >= duration {
                        self.alpha = 1
                    }
                    else {
                        self.blink(duration, speed: speed, accumalatedTime: accumalatedTime + speed, hide: !hide)
                    }
                }
            )
        }
        
        func expand() {
            UIView.animateWithDuration(0.075, animations: {self.transform = CGAffineTransformMakeScale(1.1, 1.1)})
        }
        
        func contract() {
            UIView.animateWithDuration(0.075, animations: {self.transform = CGAffineTransformIdentity})
        }
        
        override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
            expand()
        }
        
        override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
            contract()
        }
        
        override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
            contract()
        }
        
    }

}