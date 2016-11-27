
import UIKit

class TouchView: UIView {
    
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
        
        guard let location = touches.first?.location(in: self) else { return }
        
        let size = CGSize(width: 100, height: 100)
        let origin = CGPoint(x: location.x - 50, y: location.y - 50)
        
        let circle = Circle(frame: CGRect(origin: origin, size: size))
        addSubview(circle)
        circle.scale(to: 1, fades: true) { circle.removeFromSuperview() }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
    }
    
}
