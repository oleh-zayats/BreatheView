//
//  ViewController.swift
//  BreatheView
//
//  Created by Oleh Zayats on 12/28/17.
//  Copyright © 2017 Oleh Zayats. All rights reserved.
//

import UIKit

/* Example */

class ViewController: UIViewController {
    
    @IBOutlet weak var animationsButton: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var containerView: UIView!
    
    var breatheView: BreatheView!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        breatheView = BreatheView(frame: containerView.frame)
        
        containerView.addSubview(breatheView)
        breatheView.translatesAutoresizingMaskIntoConstraints = true
        breatheView.center = CGPoint(x: containerView.bounds.midX, y: containerView.bounds.midY)
        breatheView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        
        animationsButton.titleLabel?.text = ButtonTitle.start.rawValue.uppercased()
        animationsButton.layer.cornerRadius = animationsButton.bounds.height/5
    }

    @IBAction func nodesSliderDidChangeValue(_ sender: UISlider) {
        breatheView.nodesCount = Int(floor(sender.value))
        setStateActive(false)
    }
    
    @IBAction func animationsButtonDidTouchUpInside(_ sender: UIButton) {
        setStateActive(!breatheView.isAnimating)
    }
    
    private enum ButtonTitle: String { case start, stop }
    
    private func setStateActive(_ isActive: Bool) {
        slider.isHidden = isActive
        if isActive {
            breatheView.startAnimations()
            animationsButton.setTitle(ButtonTitle.stop.rawValue.uppercased(), for: .normal)
            animationsButton.backgroundColor = .red
            animationsButton.dropShadow(.red, opacity: 0.65, radius: 8.0)
        } else {
            breatheView.stopAnimations()
            animationsButton.setTitle(ButtonTitle.start.rawValue.uppercased(), for: .normal)
            animationsButton.backgroundColor = .darkGray
            animationsButton.layer.shadowColor = UIColor.clear.cgColor
        }
    }
}

private extension UIView {
    func dropShadow(_ color: UIColor = .black, offset: CGSize = .zero, opacity: Float, radius: CGFloat) {
        layer.shadowRadius = radius
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        clipsToBounds = false
    }
}
