import SpriteKit

extension WordBrain {

    class ViewController:UIViewController {
        
        var spriteKitView:SKView!
        var viewport:CGRect!
        
        override func viewDidLoad() {
            
            viewport = UIScreen.mainScreen().bounds
            
            spriteKitView = SKView(frame: viewport)
            spriteKitView.showsFPS = true
            spriteKitView.showsNodeCount = true
            view.addSubview(spriteKitView)
            
            spriteKitView.presentScene(Scene(size: CGSizeMake(viewport.size.width, viewport.size.height)))
            
        }
        
    }

}
