//
//  UIBezierPath+Clone.swift
//  BreatheView
//
//  Created by Oleh Zayats on 12/29/17.
//  Copyright © 2017 Oleh Zayats. All rights reserved.
//

import UIKit

extension UIBezierPath {
    func clone() -> UIBezierPath {
        let path = UIBezierPath()
        path.append(self)
        return path
    }
}
