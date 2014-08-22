import UIKit

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

}