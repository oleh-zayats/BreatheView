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
        static let opacity: CGFloat = 0.65
    }
    
    private var nodeExpandedPaths = [Int: UIBezierPath]()
    
    private lazy var nodeShrinkedPath: UIBezierPath = calculateShrinkedNodePath()
    
    private lazy var radius: CGFloat = {
        return min(bounds.width, bounds.height) / 4
    }()
    
    private var nodes = [Int: CAShapeLayer]() {
        didSet {
            drawNodes()
        }
    }
    
    private var nodesCount: Int = 0 {
        didSet {
            stopAnimations()
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
                let scale = makeScaleAnimation(index: index)
                node.add(scale, forKey: "scale.animation")
            }
        }
        
        let rotation = makeRotationAnimation()
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
            node.value.compositingFilter = "screenBlendMode"
            layer.addSublayer(node.value)
        }
    }
    
    func calculateExpandedNodePath(for nodeIndex: Int) -> UIBezierPath {
        let nodeArcCenter = calculateArcCenter(for: nodeIndex)
        let nodeBezierPath = UIBezierPath(arcCenter: nodeArcCenter,
                                          radius: radius,
                                          startAngle: 0.0,
                                          endAngle: pi * 2.0,
                                          clockwise: true)
        return nodeBezierPath
    }
    
    func calculateShrinkedNodePath() -> UIBezierPath {
        let nodeBezierPath = UIBezierPath(arcCenter: bounds.center,
                                          radius: radius * Constant.scaleRatio,
                                          startAngle: 0.0,
                                          endAngle: pi * 2.0,
                                          clockwise: true)
        return nodeBezierPath
    }
    
    func calculateArcCenter(for nodeIndex: Int) -> CGPoint {
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
        let blueStartValue: CGFloat = 160.0
        let blueEndValue: CGFloat = 240.0
        let adjustmentValue = CGFloat((blueEndValue - blueStartValue) / CGFloat(nodesCount) * CGFloat(nodeIndex + 1))
        let blue = (blueStartValue + adjustmentValue) / 255
        return UIColor(red: 100/255,
                     green: 190/255,
                      blue: blue,
                     alpha: Constant.opacity).cgColor
    }
}

private extension BreatheView {
    func makeScaleAnimation(index: Int) -> CABasicAnimation {
        let pathScale = CABasicAnimation(keyPath: "path")
        pathScale.fromValue = nodeExpandedPaths[index]?.cgPath
        pathScale.toValue = nodeShrinkedPath.cgPath
        pathScale.fillMode = kCAFillModeForwards
        pathScale.isRemovedOnCompletion = false
        pathScale.duration = Constant.animationDuration
        pathScale.repeatDuration = .infinity
        pathScale.autoreverses = true
        pathScale.timingFunction = CAMediaTimingFunction(curveType: .quad, controlType: .inOut)
        return pathScale
    }
    
    func makeRotationAnimation() -> CABasicAnimation {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0.0
        rotation.toValue = -pi * 2
        rotation.duration = Constant.animationDuration
        rotation.repeatDuration = .infinity
        rotation.autoreverses = true
        rotation.timingFunction = CAMediaTimingFunction(curveType: .quad, controlType: .inOut)
        return rotation
    }
}
