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

    /**
     Set window application object.

     - Parameter window: Window object.
     */
    public static func setWindow(_ window: UIWindow) {
        self.window = window
    }

    public init() {}

    /**
     Get a NavigationController instance.

     #Function Logic
     - If `rootVC` is set, the function returns a NavigationController object as Root ViewController with the param set in the function.
     - If `rootVC` is not set, the function returns the Root ViewController of the Window object. If it does not exist, create a new NavigationController.

     - Parameter rootVC: New Root ViewController.
     */
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
