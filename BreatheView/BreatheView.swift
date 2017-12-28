//
//  BreatheView.swift
//  BreatheView
//
//  Created by Oleh Zayats on 12/28/17.
//  Copyright © 2017 Oleh Zayats. All rights reserved.
//

import UIKit

public final class BreatheView: UIView {
    
    private let animationDuration = 3.6
    private let opacity: CGFloat
    private let baseColor: UIColor
    private var nodesCount: Int {
        didSet {
            nodes.removeAll()
            for index in 0..<nodesCount {
                let node = CAShapeLayer()
                node.fillColor = calculateFillColor(for: index)
                node.path = calculateNodePath(for: index, radius: min(bounds.width, bounds.height) / 4)
                nodes.append(node)
            }
        }
    }
    
    private var nodes: [CAShapeLayer] {
        didSet {
            drawNodes()
        }
    }
    
    private var _isAnimating: Bool = false
    
    public var isBounceEnabled: Bool = true
    public var isAnimating: Bool {
        return _isAnimating
    }
    
    // MARK: - Overrides
    
    public override init(frame: CGRect) {
        self.baseColor = UIColor(hex: 0x28DEFF)
        self.opacity = 0.5
        self.nodes = []
        self.nodesCount = 0
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.drawNodes()
    }
    
    public init(withFrame frame: CGRect, baseColor: UIColor, opacity: CGFloat) {
        self.baseColor = baseColor
        self.opacity = opacity
        self.nodes = []
        self.nodesCount = 0
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.drawNodes()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public API
    
    public func setNodeCount(_ count: Int) {
        nodesCount = count
    }
    
    public func startAnimations() {
        _isAnimating = true
        
        let animations = assembleBreatheAnimationGroup()
        
        nodes.forEach { layer in
            layer.add(animations, forKey: "breathe.animation.group")
        }
        
        let rotation = createRotationAnimation()
        layer.add(rotation, forKey: "rotation.animation")
    }
    
    public func stopAnimations() {
        nodes.forEach { layer in
            layer.removeAllAnimations()
        }
    
        layer.removeAllAnimations()
        _isAnimating = false
    }
}

// MARK: - Private API
private extension BreatheView {
    func drawNodes() {
        layer.sublayers?.removeAll()
        
        nodes.forEach { node in
            node.compositingFilter = "colorBlendMode"
            layer.addSublayer(node)
        }
    }
    
    func calculateNodePath(for nodeIndex: Int, radius: CGFloat) -> CGPath {
        let arcCenter = calculateArcCenter(for: nodeIndex, radius: radius)
        let nodeBezierPath = UIBezierPath(arcCenter: arcCenter,
                                          radius: radius,
                                          startAngle: 0.0,
                                          endAngle: pi * 2.0,
                                          clockwise: true)
        return nodeBezierPath.cgPath
    }
    
    func calculateArcCenter(for nodeIndex: Int, radius: CGFloat) -> CGPoint {
        /* let 'a' be the angle, (x, y) the center point and r the radius:
         * (x + r * cos(a), y + r * sin(a))
         */
        let count = CGFloat(nodesCount)
        
        let a = (pi * 2) * CGFloat(nodeIndex + 1) / count
        let x = frame.center.x
        let y = frame.center.y
        
        let xPos = x + radius * cos(a)
        let yPos = y + radius * sin(a)
        
        return CGPoint(x: xPos, y: yPos)
    }
    
    func calculateFillColor(for nodeIndex: Int) -> CGColor {
        guard let rgb = baseColor.cgColor.components else {
            return baseColor.cgColor
        }
        let red  = (CGFloat(nodeIndex) / CGFloat(nodesCount - 1)) * rgb[0]
        let blue = (CGFloat(nodeIndex) / CGFloat(nodesCount - 1)) * rgb[2]
        
        return UIColor(red: red,
                     green: rgb[1],
                      blue: blue,
                     alpha: opacity).cgColor
    }
}

// MARK: - Animations
private extension BreatheView {
    func assembleBreatheAnimationGroup() -> CAAnimationGroup {
        let group = CAAnimationGroup()
        group.duration = animationDuration
        group.repeatDuration = .infinity
        group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        group.autoreverses = true
        let scale = createScaleAnimation()
        group.animations = [ scale ]
        return group
    }
    
    func createScaleAnimation() -> CABasicAnimation {
        let midX = bounds.midX
        let midY = bounds.midY
        let scale = CABasicAnimation(keyPath: "transform")
        var transformScale: CATransform3D = CATransform3DIdentity
        transformScale = CATransform3DTranslate(transformScale, midX, midY, 0)
        transformScale = CATransform3DScale(transformScale, 0.15, 0.15, 1)
        transformScale = CATransform3DTranslate(transformScale, -midX, -midY, 0)
        scale.toValue = NSValue(caTransform3D: transformScale)
        return scale
    }
    
    func createRotationAnimation() -> CABasicAnimation {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0.0
        rotation.toValue = pi * 2
        rotation.duration = animationDuration
        rotation.repeatDuration = .infinity
        rotation.autoreverses = true
        rotation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        return rotation
    }
}

// MARK: - Extensions
private extension UIBezierPath {
    var center: CGPoint { return bounds.center }
}

private extension CGRect {
    var center: CGPoint { return CGPoint(x: midX, y: midY) }
}

private extension UIColor {
    convenience init(hex: Int) {
        let r = CGFloat((hex >> 16) & 0xff) / 255
        let g = CGFloat((hex >> 08) & 0xff) / 255
        let b = CGFloat((hex >> 00) & 0xff) / 255
        self.init(red: r, green: g, blue: b, alpha: 1)
    }
}

// MARK: - Math
private let pi = CGFloat(Double.pi) // pi is approx. equal to 3.14159265359
private func radians(fromDegrees degrees: CGFloat) -> CGFloat {
    return (pi * degrees) / 180.0
}

