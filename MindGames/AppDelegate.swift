import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var viewController:GTWViewController!
    var window: UIWindow!
    
    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        viewController = GTWViewController()
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window.backgroundColor = UIColor.whiteColor()
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(application: UIApplication!) {
    }

    func applicationDidEnterBackground(application: UIApplication!) {
    }

    func applicationWillEnterForeground(application: UIApplication!) {
    }

    func applicationDidBecomeActive(application: UIApplication!) {
    }

}

