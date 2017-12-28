//
//  ViewController.swift
//  BreatheView
//
//  Created by Oleh Zayats on 12/28/17.
//  Copyright © 2017 Oleh Zayats. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var animationsButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    var breatheView: BreatheView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationsButton.titleLabel?.text = "Start"
        animationsButton.layer.cornerRadius = 6.0

        breatheView = BreatheView(frame: containerView.frame)
        containerView.addSubview(breatheView)
        
        breatheView.translatesAutoresizingMaskIntoConstraints = true
        breatheView.center = CGPoint(x: containerView.bounds.midX, y: containerView.bounds.midY)
        breatheView.autoresizingMask = [.flexibleLeftMargin,
                                        .flexibleRightMargin,
                                        .flexibleTopMargin,
                                        .flexibleBottomMargin]
        
        breatheView.setNodeCount(6)
    }

    @IBAction func nodesSliderDidChangeValue(_ sender: UISlider) {
        breatheView.setNodeCount(Int(floor(sender.value)))
    }
    
    @IBAction func animationsButtonDidTouchUpInside(_ sender: UIButton) {
        if breatheView.isAnimating == false {
            breatheView.startAnimations()
            animationsButton.setTitle("Stop", for: .normal)
        } else {
            breatheView.stopAnimations()
            animationsButton.setTitle("Start", for: .normal)
        }
    }
}

