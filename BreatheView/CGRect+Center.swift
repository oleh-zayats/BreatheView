//
//  CGRect+Center.swift
//  BreatheView
//
//  Created by Oleh Zayats on 12/29/17.
//  Copyright © 2017 Oleh Zayats. All rights reserved.
//

import UIKit

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
}
