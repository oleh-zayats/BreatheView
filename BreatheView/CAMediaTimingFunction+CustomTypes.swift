//
//  CACAMediaTimingFunction+CustomTypes.swift
//  BreatheView
//
//  Created by Oleh Zayats on 12/29/17.
//  Copyright © 2017 Oleh Zayats. All rights reserved.
//

import UIKit

/* More about Easing Curves: http://easings.net/en
 */
enum EasingCurveType {
    case sine, quad, cubic, quart, quint, exp, circ, back
}

enum ControlType {
    case `in`, out, inOut
}

extension CAMediaTimingFunction {
    convenience init(curveType: EasingCurveType, controlType: ControlType) {
        switch controlType {
        case .`in`:
            switch curveType {
            case .sine:
                self.init(controlPoints: 0.45, 0.00, 1.00, 1.00)
            case .quad:
                self.init(controlPoints: 0.43, 0.00, 0.82, 0.60)
            case .cubic:
                self.init(controlPoints: 0.67, 0.00, 0.84, 0.54)
            case .quart:
                self.init(controlPoints: 0.81, 0.00, 0.77, 0.34)
            case .quint:
                self.init(controlPoints: 0.89, 0.00, 0.81, 0.27)
            case .exp:
                self.init(controlPoints: 1.04, 0.00, 0.88, 0.49)
            case .circ:
                self.init(controlPoints: 0.60, 0.00, 1.00, 0.45)
            case .back:
                self.init(controlPoints: 0.77,-0.63, 1.00, 1.00)
            }
        case .out:
            switch curveType {
            case .sine:
                self.init(controlPoints: 0.00, 0.00, 0.55, 1.00)
            case .quad:
                self.init(controlPoints: 0.18, 0.40, 0.57, 1.00)
            case .cubic:
                self.init(controlPoints: 0.16, 0.46, 0.33, 1.00)
            case .quart:
                self.init(controlPoints: 0.23, 0.66, 0.19, 1.00)
            case .quint:
                self.init(controlPoints: 0.19, 0.73, 0.11, 1.00)
            case .exp:
                self.init(controlPoints: 0.12, 0.51,-0.40, 1.00)
            case .circ:
                self.init(controlPoints: 1.00, 0.55, 0.40, 1.00)
            case .back:
                self.init(controlPoints: 0.00, 0.00, 0.23, 1.37)
            }
        case .inOut:
            switch curveType {
            case .sine:
                self.init(controlPoints: 0.45, 0.00, 0.55, 1.00)
            case .quad:
                self.init(controlPoints: 0.43, 0.00, 0.57, 1.00)
            case .cubic:
                self.init(controlPoints: 0.65, 0.00, 0.35, 1.00)
            case .quart:
                self.init(controlPoints: 0.81, 0.00, 0.19, 1.00)
            case .quint:
                self.init(controlPoints: 0.90, 0.00, 0.10, 1.00)
            case .exp:
                self.init(controlPoints: 0.95, 0.00, 0.05, 1.00)
            case .circ:
                self.init(controlPoints: 0.82, 0.00, 0.18, 1.00)
            case .back:
                self.init(controlPoints: 0.77,-0.63, 0.23, 1.37)
            }
        }
    }
}
