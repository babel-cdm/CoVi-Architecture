//
//  CoViViewUtils.swift
//  CoVi
//
//  Created by Jorge Guilabert Ibáñez on 07/02/2020.
//  Copyright © 2020 Babel SI. All rights reserved.
//

import UIKit

public struct CoViViewUtils {

    public static func getContainerConstraints(item: NSObject, toItem: NSObject) -> [NSLayoutConstraint] {
        let topConstraint = NSLayoutConstraint(item: item, attribute: .top, relatedBy: .equal,
                                               toItem: toItem, attribute: .top,
                                               multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: item, attribute: .bottom, relatedBy: .equal,
                                                  toItem: toItem, attribute: .bottom,
                                                  multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: item, attribute: .leading, relatedBy: .equal,
                                                   toItem: toItem, attribute: .leading,
                                                   multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: item, attribute: .trailing, relatedBy: .equal,
                                                    toItem: toItem, attribute: .trailing,
                                                    multiplier: 1, constant: 0)

        return [topConstraint, bottomConstraint, leadingConstraint, trailingConstraint]
    }

    public static func getCenterConstraints(item: NSObject, toItem: NSObject) -> [NSLayoutConstraint] {
        let centerHorConstraint = NSLayoutConstraint(item: item, attribute: .centerX, relatedBy: .equal,
                                                     toItem: toItem, attribute: .centerX,
                                                     multiplier: 1, constant: 0)
        let centerVerConstraint = NSLayoutConstraint(item: item, attribute: .centerY, relatedBy: .equal,
                                                     toItem: toItem, attribute: .centerY,
                                                     multiplier: 1, constant: 0)

        return [centerHorConstraint, centerVerConstraint]
    }

}
