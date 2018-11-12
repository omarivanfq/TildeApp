import UIKit

class Option: NSObject {
    
    var content:String?
    var button:UIButton
    var x:CGFloat
    var y:CGFloat
    var speed:CGFloat
    var up:Bool
    
    init (content:String, button:UIButton) {
        self.button = button
        self.button.setTitle(content, for: .normal)
        self.content = content
        x = button.frame.origin.x
        y = button.frame.origin.y
        self.up = arc4random_uniform(2) == 0
        speed = 1
    }
    
    func setSpeed(speed:CGFloat) {
        self.speed = speed
    }
    
    func act() {
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        if self.y >= screenHeight + 200 || self.y <= -200 - self.button.frame.height {
            reallocate()
        }
        if up {
            self.y = self.y - (screenHeight / 700 * self.speed)
        }
        else {
            self.y = self.y + (screenHeight / 700 * self.speed)
        }
        
        self.button.frame.origin.y = self.y
    }
    
    func reallocate() {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let rand = Float.random(in: 0...1)
        self.x = (screenWidth - self.button.frame.width) * CGFloat(rand)
        
        self.up = Bool.random()
        
        if self.up {
            self.y = (screenHeight + self.button.frame.height + CGFloat(Float.random(in:0...250)))
        }
        else {
            self.y = -self.button.frame.height - (CGFloat(1 + Float.random(in: 0 ... 100)))
        }
        
        self.speed = CGFloat(Float.random(in: 1 ... 1.5))
        
        button.frame.origin.x = self.x
        button.frame.origin.y = self.y
        button.isEnabled = true
    }
    
}
