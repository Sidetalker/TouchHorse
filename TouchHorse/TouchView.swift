
import UIKit

struct TouchMetadata {
    var circle: Circle
    var startLocation: CGPoint
}

protocol TouchViewDelegate {
    func registeredTouch(at location: CGPoint, for duration: TimeInterval)
}

class TouchView: UIView {
    
    var touchData = [UITouch : TouchMetadata]()
    var delegate: TouchViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        backgroundColor = .clear
        isMultipleTouchEnabled = true
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        touches.forEach { startTracking(touch: $0) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        for touch in touches {
            guard let touchData = touchData[touch] else { continue }
            let location = touch.location(in: self)
            let startLocation = touchData.startLocation
            
            if abs(location.x - startLocation.x) > 25 || abs(location.y - startLocation.y) > 25 {
                stopTracking(touch: touch)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        touches.forEach { stopTracking(touch: $0) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        touches.forEach { stopTracking(touch: $0) }
    }
    
    func startTracking(touch: UITouch) {
        let location = touch.location(in: self)
        let size = CGSize(width: 150, height: 150)
        let origin = CGPoint(x: location.x - 75, y: location.y - 75)
        let circle = Circle(frame: CGRect(origin: origin, size: size))
        addSubview(circle)
        circle.scale(to: 0.8, fades: false)
        
        self.touchData[touch] = TouchMetadata(circle: circle, startLocation: location)
    }
    
    func stopTracking(touch: UITouch) {
        guard let circle = touchData[touch]?.circle else { return }
        
        circle.scale(to: 1, fades: true) { circle.removeFromSuperview() }
        touchData.removeValue(forKey: touch)
    }
    
}
