import UIKit

extension ColorOfDeception {

    class ViewController: UIViewController {
        
        var clock:Clock!
        var grid:ColorOfDeception.Grid!
        var score:Double = 0
        var scoreLabel:UILabel!
        var scoreLink:DisplayLink!
        var viewport:CGRect!
        
        override func viewDidLoad() {
            
            super.viewDidLoad()
            
            viewport = UIScreen.mainScreen().bounds
            view.backgroundColor = UIColor.whiteColor()

            scoreLabel = UILabel(frame: CGRectMake(8, 8, viewport.size.width, 24))
            scoreLabel.font = UIFont(name: "AvenirNext-Medium", size: 14)
            scoreLabel.text = "0"
            view.addSubview(scoreLabel)
            
            clock = Clock(frame: CGRectMake(viewport.size.width - 32, 8, 24, 24), color: (0,0,0), minAlpha: 0.2, maxAlpha: 0.5)
            clock.animateWithDuration(30)
            view.addSubview(clock)

            grid = ColorOfDeception.Grid(minSize: 2, maxSize: 4, minTileSize: 50, maxTileSize: 100, colors: [
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
        
        func setScore(score:Double) {
            var deltaScore = (score - self.score)
            scoreLink = DisplayLink(
                duration: 0.4,
                onChange: {
                    (l:DisplayLink) in
                    self.scoreLabel.text = String(Int(self.score + (deltaScore * l.p)))
                    return
                },
                onComplete: {
                    (l:DisplayLink) in
                    self.score = score
                }
            )
        }
        
        func onTap(tap:UITapGestureRecognizer) {
            
            var tile = view.hitTest(tap.locationInView(tap.view), withEvent: nil) as? ColorOfDeception.Tile
            
            if tile != nil {
                
                if tile!.defective {
                    grid.refresh()
                    self.setScore(score + 800)
                }
                    
                else {
                    tile!.blink(0.2, speed: 0.04, accumalatedTime: 0, hide: true)
                    self.setScore(score - 200)
                }
                
            }
            
        }

    }

}