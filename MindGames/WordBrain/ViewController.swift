import SpriteKit

extension WordBrain {

    class ViewController:UIViewController {
        
        var spriteKitScene:Scene!
        var spriteKitView:SKView!
        var viewport:CGRect!
        
        override func viewDidLoad() {
            
            viewport = UIScreen.mainScreen().bounds
            
            spriteKitView = SKView(frame: viewport)
            spriteKitView.showsFPS = true
            spriteKitView.showsNodeCount = true
            
            spriteKitScene = Scene(size: CGSizeMake(viewport.size.width, viewport.size.height))
            spriteKitView.presentScene(spriteKitScene)
            
            view.addSubview(spriteKitView)
            
        }
        
    }

}
