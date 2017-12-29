//
//  BreatheView.swift
//  BreatheView
//
//  Created by Oleh Zayats on 12/28/17.
//  Copyright © 2017 Oleh Zayats. All rights reserved.
//

import UIKit

public final class BreatheView: UIView {
    
    private enum Constant {
        static let animationDuration = 3.55
        static let scaleRatio: CGFloat = 0.1
        static let opacity: CGFloat = 0.5
        static let startColor = UIColor(hex: 0x1DE1F7)
    }
    
    private var nodeExpandedPaths = [Int: UIBezierPath]()
    
    private lazy var nodeShrinkedPath: UIBezierPath = calculateShrinkedNodePath()
    
    private lazy var layerRadius: CGFloat = {
        return min(bounds.width, bounds.height) / 4
    }()
    
    private var nodes = [Int: CAShapeLayer]() {
        didSet {
            drawNodes()
        }
    }
    
    private var nodesCount: Int = 0 {
        didSet {
            makeNodes()
        }
    }
    
    private var _isAnimating: Bool = false
    
    public var isBounceEnabled: Bool = true
    public var isAnimating: Bool {
        return _isAnimating
    }
    
    // MARK: - Overrides
    
    public override init(frame: CGRect) {
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
        
        for index in 0..<nodesCount {
            if let node = nodes[index] {
                let scale = createScaleAnimation(index: index)
                node.add(scale, forKey: "scale.animation")
            }
        }
        let rotation = createRotationAnimation()
        layer.add(rotation, forKey: "rotation.animation")
    }
    
    public func stopAnimations() {
        nodes.forEach { node in
            node.value.removeAllAnimations()
        }
        
        layer.removeAllAnimations()
        _isAnimating = false
    }
}

// MARK: - Private API
private extension BreatheView {
    func makeNodes() {
        nodes.removeAll()
        nodeExpandedPaths.removeAll()
        for index in 0..<nodesCount {
            
            let expandedPath = calculateExpandedNodePath(for: index)
            nodeExpandedPaths[index] = expandedPath
            
            let node = CAShapeLayer()
            node.path = expandedPath.cgPath
            node.fillColor = calculateFillColor(for: index)
            nodes[index] = node
        }
    }
    
    func drawNodes() {
        layer.sublayers?.removeAll()
        
        nodes.forEach { node in
            node.value.compositingFilter = "colorBlendMode"
            layer.addSublayer(node.value)
        }
    }
    
    func calculateExpandedNodePath(for nodeIndex: Int) -> UIBezierPath {
        let nodeArcCenter = calculateArcCenter(for: nodeIndex, radius: layerRadius)
        let nodeBezierPath = UIBezierPath(arcCenter: nodeArcCenter,
                                          radius: layerRadius,
                                          startAngle: 0.0,
                                          endAngle: pi * 2.0,
                                          clockwise: true)
        return nodeBezierPath
    }
    
    func calculateShrinkedNodePath() -> UIBezierPath {
        let nodeBezierPath = UIBezierPath(arcCenter: bounds.center,
                                          radius: layerRadius * Constant.scaleRatio,
                                          startAngle: 0.0,
                                          endAngle: pi * 2.0,
                                          clockwise: true)
        return nodeBezierPath
    }
    
    func calculateArcCenter(for nodeIndex: Int, radius: CGFloat) -> CGPoint {
        /* let (x, y) be the frames's center point
         * formula: (x + layerRadius * cos(angle), y + layerRadius * sin(angle))
         */
        let a = (pi * 2) * CGFloat(nodeIndex + 1) / CGFloat(nodesCount)
        let x = frame.center.x
        let y = frame.center.y
        
        let xPos = x + radius * cos(a)
        let yPos = y + radius * sin(a)
        
        return CGPoint(x: xPos, y: yPos)
    }
    
    func calculateFillColor(for nodeIndex: Int) -> CGColor {
        guard let rgb = Constant.startColor.cgColor.components else {
            return Constant.startColor.cgColor
        }
        let red  = (CGFloat(nodeIndex) / CGFloat(nodesCount - 1)) * rgb[0]
        let blue = (CGFloat(nodeIndex) / CGFloat(nodesCount - 1)) * rgb[2]
        return UIColor(red: red, green: rgb[1], blue: blue, alpha: Constant.opacity).cgColor
    }
}

private extension BreatheView {
    func createScaleAnimation(index: Int) -> CABasicAnimation {
        let pathScale = CABasicAnimation(keyPath: "path")
        let fromPath: UIBezierPath? = nodeExpandedPaths[index]
        let toPath: UIBezierPath = nodeShrinkedPath
        
        pathScale.fromValue = fromPath?.cgPath
        pathScale.toValue = toPath.cgPath
        
        pathScale.fillMode = kCAFillModeForwards
        pathScale.isRemovedOnCompletion = false
        
        pathScale.duration = Constant.animationDuration
        pathScale.repeatDuration = .infinity
        pathScale.autoreverses = true
        pathScale.timingFunction = CAMediaTimingFunction(name: .quad, controlType: .inOut)
        
        return pathScale
    }
    
    func createRotationAnimation() -> CABasicAnimation {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0.0
        rotation.toValue = -pi * 2
        rotation.duration = Constant.animationDuration
        rotation.repeatDuration = .infinity
        rotation.autoreverses = true
        rotation.timingFunction = CAMediaTimingFunction(name: .quad, controlType: .inOut)
        return rotation
    }
}
