import UIKit

class DisplayLink:NSObject {
    
    enum State {
        case BEGIN
        case CHANGE
        case END
    }
    
    var duration:Double!
    var link:CADisplayLink!
    var onChange:(DisplayLink) -> Void!
    var onComplete:(DisplayLink) -> Void!
    var p:Double = 0
    var startTime:Double!
    var state:State!
    var target:AnyObject!
   
    init(duration:Double, onChange:(DisplayLink) -> Void, onComplete:(DisplayLink) -> Void) {
        self.duration = duration
        self.onChange = onChange
        self.onComplete = onComplete
        super.init()
        self.start()
    }
    
    func start() {
        
        startTime = CACurrentMediaTime()
        
        if link == nil {
            link = CADisplayLink(target: self, selector: "onLinkRefresh")
            link.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
        }
        
        state = State.BEGIN
        p = 0
        
        self.onChange(self)
        
        link.paused = false
        
    }
    
    func stop() {
        link.paused = true
    }
    
    func onLinkRefresh() {
        
        var t = clamp((CACurrentMediaTime() - startTime) / duration, 0, 1)
        
        state = t >= 1 ? State.END : State.CHANGE
        p = sin(t * (M_PI / 2.0))
        
        self.onChange(self)
        
        if t >= 1 {
            self.stop()
            self.onComplete(self)
        }
        
    }
    
}