//
//  CoViApplication.swift
//  CoVi
//
//  Created by Jorge Guilabert Ibáñez on 19/07/2019.
//  Copyright © 2019 Babel SI. All rights reserved.
//

import UIKit

open class CoViApplication {

    private static var window: UIWindow!

    public static func setWindow(_ window: UIWindow) {
        self.window = window
    }

    public init() {}

    public static func getNavigationController(rootVC: UIViewController? = nil) -> UINavigationController {

        if let rootVC = rootVC {
            return UINavigationController(rootViewController: rootVC)
        } else {
            let navigationController = window.rootViewController as? UINavigationController

            if let navigationController = navigationController {
                return navigationController
            } else {
                return UINavigationController()
            }
        }
    }

}
