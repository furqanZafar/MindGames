import UIKit


func randN(max:Int, count:Int) -> Array<Int> {
    
    var numbers:Array<Int> = []
    var number:Int!
    
    for i in 0...count - 1 {
    
        do {
            number = Int(rand()) % max
        } while(find(numbers, number) != nil)
        
        numbers.append(number)
        
    }
    
    return numbers
    
}


class Color: UIColor {
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override init(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        super.init(hue: hue / 360.0, saturation: saturation / 100.0, brightness: brightness / 100.0, alpha: alpha)
    }
    
}

class Tile: UIView {
    
    var defective:Bool = false
    var label:UILabel!
    var shadow:UIImageView!
    
    required init(coder aDecoder: NSCoder!) {
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

class Grid: UIView {
    
    var minSize:CGFloat!
    var maxSize:CGFloat!
    var minTileSize:CGFloat!
    var maxTileSize:CGFloat!
    var colors:Array<(name:String, color:UIColor)>!
    var size:Int = 0
    
    required init(coder aDecoder: NSCoder!) {
        return super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init (minSize:CGFloat, maxSize:CGFloat, minTileSize:CGFloat, maxTileSize:CGFloat, colors:Array<(name:String, color:UIColor)>) {
        super.init()
        self.minSize = minSize
        self.maxSize = maxSize
        self.minTileSize = minTileSize
        self.maxTileSize = maxTileSize
        self.colors = colors
    }
    
    func setSize(size:CGFloat) {
        self.size = Int(size)
        var tileSize:CGFloat = maxTileSize - (((size - minSize) / (maxSize - minSize)) * (maxTileSize - minTileSize))
        for i in 0...self.size - 1 {
            for j in 0...self.size - 1 {
                var frame:CGRect = CGRectMake(CGFloat(j) * (tileSize + 10), CGFloat(i) * (tileSize + 10), tileSize, tileSize)
                var tag:Int = 1000 + (i * self.size) + j
                var tile:Tile! = self.viewWithTag(tag) as Tile?
                if tile == nil {
                    tile = Tile(frame: frame)
                    tile.tag = tag
                }
                self.addSubview(tile)
            }
        }
        var frame = self.frame
        frame.size.width = size * (tileSize + 10) - 10
        frame.size.height = size * (tileSize + 10) - 10
        self.frame = frame
    }
    
    func refresh() {
        
        var indices = randN(self.colors.count, self.size * self.size)
        
        for i in 0...self.size - 1 {
            for j in 0...self.size - 1 {
                var index:Int = (i * self.size) + j
                var tag:Int = 1000 + index
                var tile:Tile! = self.viewWithTag(tag) as Tile?
                tile.defective = false
                var tuple = self.colors[indices[index]]
                tile.backgroundColor = tuple.color
                tile.setText(tuple.name)
            }
        }
        
        var defectiveTile:Tile = self.viewWithTag(1000 + Int(rand()) % (self.size * self.size)) as Tile
        defectiveTile.defective = true
        
        for i in 0...self.colors.count - 1 {
            if (find(indices, i) == nil) {
                defectiveTile.setText(self.colors[i].name)
                break
            }
        }
        
    }
    
}


class ViewController: UIViewController {
    
    var fill:UIView!
    var grid:Grid!
    var timer:UILabel!
    var time:Int = 0
    var viewport:CGRect!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewport = UIScreen.mainScreen().bounds
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.975)
        
        timer = UILabel(frame: CGRectMake(0, 0, viewport.size.width, 88))
        timer.backgroundColor = Color(hue: 204, saturation: 69, brightness: 84, alpha: 0.4)
        timer.font = UIFont(name: "HelveticaNeue", size: 44)
        timer.text = "00"
        timer.textAlignment = NSTextAlignment.Center
        timer.textColor = UIColor.blackColor()
        view.addSubview(timer)
        
        var bar = UIView(frame: CGRectMake(0, timer.bounds.size.height, viewport.size.width, 4))
        bar.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        view.addSubview(bar)
        
        fill = UIView(frame: CGRectMake(0, 0, 0, bar.bounds.size.height))
        fill.backgroundColor = UIColor.greenColor()
        bar.addSubview(fill)
        
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "onTick", userInfo: nil, repeats: true)
        
        grid = Grid(minSize: 2, maxSize: 4, minTileSize: 50, maxTileSize: 100, colors: [
            (name:"Red", color:Color(hue: 335, saturation: 67, brightness: 91, alpha: 1)),
            (name:"Yellow", color:Color(hue: 41, saturation: 100, brightness: 97, alpha: 1)),
            (name:"Green", color:Color(hue: 111, saturation: 51, brightness: 60, alpha: 1)),
            (name:"Blue", color:Color(hue: 204, saturation: 69, brightness: 84, alpha: 1)),
            (name:"White", color:UIColor.whiteColor()),
            (name:"Black", color:UIColor.blackColor())
        ])
        grid.setSize(2)
        grid.refresh()
        grid.center = CGPointMake(viewport.size.width / 2, viewport.size.height / 2)
        view.addSubview(grid)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onTap:"))
        
    }
    
    func onTap(tap:UITapGestureRecognizer) {
        
        var tile = view.hitTest(tap.locationInView(tap.view), withEvent: nil) as? Tile
        
        if tile != nil {
            
            var frame = self.fill.frame
            var score:CGFloat = (tile!.defective ? 1 : -1) * 20
            frame.size.width = max(0, min(viewport.size.width, frame.size.width + score))
            self.fill.frame = frame
            
            if tile!.defective {
                grid.refresh()
            }
                
            else {
                tile!.blink(0.2, speed: 0.04, accumalatedTime: 0, hide: true)
            }
            
        }
        
    }
    
    func onTick() {
        time += 1
        timer.text = (time < 10 ? "0" : "") + String(time)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}