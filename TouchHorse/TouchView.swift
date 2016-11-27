//
//  TouchView.swift
//  TouchHorse
//
//  Created by Kevin Sullivan on 11/27/16.
//  Copyright © 2016 Kevin Sullivan. All rights reserved.
//

import UIKit

struct TouchMetadata {
    var circle: Circle
    var startLocation: CGPoint
    var startTime: Date
    var duration: Int?
    
    init(circle: Circle, startLocation: CGPoint) {
        self.circle = circle
        self.startLocation = startLocation
        self.startTime = Date()
    }
    
    init(metadata: TouchMetadata, duration: Int) {
        self.circle = metadata.circle
        self.startLocation = metadata.startLocation
        self.startTime = metadata.startTime
        self.duration = duration
    }
}

protocol TouchViewDelegate {
    func registeredTouch(with metadata: TouchMetadata)
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
        guard let data = touchData[touch] else { return }
        
        delegate?.registeredTouch(with: data)
        data.circle.scale(to: 1, fades: true) { data.circle.removeFromSuperview() }
        touchData.removeValue(forKey: touch)
    }
    
}
