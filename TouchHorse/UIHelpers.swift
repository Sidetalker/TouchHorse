
import UIKit

class Circle: UIView {
    
    override class var layerClass: AnyClass { return CircleAnimationLayer.self }
    
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
        layer.setNeedsDisplay()
    }
    
    func scale(to scale: CGFloat, fades doesFade: Bool, completion: @escaping () -> Void) {
        let duration = 1.0
        let timing = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        CATransaction.setAnimationTimingFunction(timing)
        (layer as? CircleAnimationLayer)?.scale = 1
        CATransaction.commit()
        
        UIView.animate(withDuration: 0.5, delay: 0.5, options: [], animations: {
            self.alpha = 0
        }, completion: { _ in completion() })
    }
    
    override func draw(_ layer: CALayer, in ctx: CGContext) {
        guard let animationLayer = layer as? CircleAnimationLayer else { return }
        
        UIGraphicsPushContext(ctx)
        ProStylin.drawCircle(frame: bounds, resizing: .center, circleScale: animationLayer.scale)
        UIGraphicsPopContext()
    }
    
}

class CircleAnimationLayer: CALayer {
    
    @NSManaged var scale: CGFloat
    @NSManaged var color: UIColor
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init()
    {
        super.init()
        scale = 0
    }
    
    override init(layer: Any)
    {
        super.init(layer: layer)
        
        if let layer = layer as? CircleAnimationLayer {
            scale = layer.scale
            color = layer.color
        }
    }
    
    override class func needsDisplay(forKey key: String) -> Bool
    {
        let homeboys = ["scale", "color"]
        
        if homeboys.contains(key) { return true }
        
        return super.needsDisplay(forKey: key)
    }
    
    override func action(forKey key: String) -> CAAction?
    {
        if key == "scale" {
            let animation = CABasicAnimation(keyPath: key)
            animation.fromValue = presentation()?.value(forKey: key) ?? 0
            return animation
        }
        
        if key == "color" {
            let animation = CABasicAnimation(keyPath: key)
            animation.fromValue = presentation()?.value(forKey: key) ?? UIColor.black
            return animation
        }
        
        return super.action(forKey: key)
    }

}
