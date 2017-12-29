//
//  Math.swift
//  BreatheView
//
//  Created by Oleh Zayats on 12/29/17.
//  Copyright © 2017 Oleh Zayats. All rights reserved.
//

import UIKit

internal let pi = CGFloat(Double.pi) // pi is approx. equal to 3.14159265359
internal func radians(fromDegrees degrees: CGFloat) -> CGFloat {
    return (pi * degrees) / 180.0
}
