//
//  CoViWireframe.swift
//  CoVi
//
//  Created by Jorge Guilabert Ibáñez on 19/07/2019.
//  Copyright © 2019 Babel SI. All rights reserved.
//

import UIKit

enum RouteTransitionType {
    case root
    case push
    case pushModal
    case modal
}

public protocol CoViWireframeProtocol: class {
    func popToRoot(animated: Bool)
    func pop(animated: Bool)
    func popModal(animated: Bool)
    func popModalToRoot(animated: Bool)
    func dismissModal(animated: Bool)
    func popGesture()
    func dismissGesture()
}

open class CoViWireframe {

    // MARK: - Properties

    var routerStack: [[UIViewController: RouteTransitionType]] = []

    // MARK: - Initializer

    public init() {}

    // MARK: - Private functions

    private func getLastNavigationController() -> UINavigationController? {
        var navigationController: UINavigationController?

        for router in routerStack.reversed() {
            if let navController = router.keys.first as? UINavigationController {
                navigationController = navController
                break
            }
        }

        return navigationController
    }

    private func getLastViewController(with routeTransitionType: RouteTransitionType? = nil) -> UIViewController? {
        var viewController: UIViewController?

        for router in routerStack.reversed() {
            if let vController = router.keys.first, let transitionType = router.values.first {
                if let routeTransitionType = routeTransitionType {
                    if routeTransitionType == transitionType {
                        viewController = vController
                        break
                    }
                } else {
                    viewController = vController
                    break
                }
            }
        }

        return viewController
    }

    private func getTotalViewsFromLastNavController() -> Int {
        var totaViewControllers = 0

        for router in routerStack.reversed() {
            if let transitionType = router.values.first {
                if transitionType != .root {
                    totaViewControllers += 1
                } else {
                    break
                }
            }
        }

        return totaViewControllers
    }

    private func isViewInStack(_ view: UIViewController) -> Bool {
        var isInStack = false

        for router in routerStack {
            if router.keys.first == view {
                isInStack = true
                break
            }
        }

        return isInStack
    }

    private func addViewToStack(_ view: UIViewController, _ routeTransitionType: RouteTransitionType) {
        if !isViewInStack(view) {
            routerStack.append([view: routeTransitionType])
        }
    }

    private func removeViewsToStackFromPushRoot(_ view: UIViewController) {
        for routerEnumerated in routerStack.enumerated() {
            if view == routerEnumerated.element.keys.first {
                let lastIndex = routerStack.count - 1

                /** position "0" is root
                 position "1" is the root VC
                 position "2" is the VC from which we want to remove
                 */
                let nextVcRootIndex = routerEnumerated.offset + 2 // +2 for the reason explained above

                if nextVcRootIndex <= lastIndex {
                    routerStack.removeSubrange(nextVcRootIndex...lastIndex)
                }
                break
            }
        }
    }

    private func removeViewsToStackFromPresentModal(_ view: UIViewController) {
        for routerEnumerated in routerStack.enumerated() {
            if view == routerEnumerated.element.keys.first {
                routerStack.removeSubrange(routerEnumerated.offset...routerStack.count - 1)

                if routerStack.last?.values.first == .root {
                    routerStack.removeLast()
                }
                break
            }
        }
    }

    // MARK: - Public functions

    public func getViewFromStoryboard(name: String) -> UIViewController {
        let storyboard: UIStoryboard = UIStoryboard(name: name, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: name)
    }

    public func pushRoot(view: UIViewController, animated: Bool = true) {
        let navigationController = CoViApplication.getNavigationController(rootVC: view)
        navigationController.pushRootViewController(animated: animated)

        routerStack.removeAll()
        addViewToStack(navigationController, .root)
        addViewToStack(view, .push)
    }

    public func push(view: UIViewController, animated: Bool = true) {
        let navigationController = getLastNavigationController() ?? CoViApplication.getNavigationController()
        navigationController.pushViewController(view, animated: animated)

        addViewToStack(navigationController, .root)
        addViewToStack(view, .push)
    }

    public func pushModal(view: UIViewController, animated: Bool = true) {
        let navigationController = getLastNavigationController() ?? CoViApplication.getNavigationController()
        navigationController.pushModalViewController(view, animated: animated)

        addViewToStack(navigationController, .root)
        addViewToStack(view, .pushModal)
    }

    public func presentModal(view: UIViewController, animated: Bool = true) {
        let lastViewController = getLastViewController() ?? CoViApplication.getNavigationController()
        lastViewController.present(view, animated: animated, completion: nil)

        if let navigationController = view as? UINavigationController {
            addViewToStack(navigationController, .root)
            for viewEnumerated in navigationController.viewControllers.enumerated() {
                if viewEnumerated.offset == 0 {
                    addViewToStack(viewEnumerated.element, .modal)
                } else {
                    addViewToStack(viewEnumerated.element, .push)
                }
            }
        } else {
            addViewToStack(view, .modal)
        }
    }

    // MARK: - CoViWireframeProtocol

    public func popToRoot(animated: Bool = true) {
        let navigationController = getLastNavigationController() ?? CoViApplication.getNavigationController()
        navigationController.popToRootViewController(animated: animated)

        removeViewsToStackFromPushRoot(navigationController)
    }

    public func pop(animated: Bool = true) {
        let navigationController = getLastNavigationController() ?? CoViApplication.getNavigationController()
        navigationController.popViewController(animated: animated)

        popGesture()
    }

    public func popModal(animated: Bool = true) {
        let navigationController = getLastNavigationController() ?? CoViApplication.getNavigationController()
        navigationController.popModalViewController(animated: animated)

        popGesture()
    }

    public func popModalToRoot(animated: Bool = true) {
        let navigationController = getLastNavigationController() ?? CoViApplication.getNavigationController()
        navigationController.popModalViewController(toRootVc: true, animated: animated)

        removeViewsToStackFromPushRoot(navigationController)
    }

    public func dismissModal(animated: Bool = true) {
        let lastViewController = getLastViewController(with: .modal) ?? CoViApplication.getNavigationController()
        lastViewController.dismiss(animated: animated, completion: nil)

        removeViewsToStackFromPresentModal(lastViewController)
    }

    public func popGesture() {
        if getTotalViewsFromLastNavController() > 1 {
            routerStack.removeLast()
        }
    }

    public func dismissGesture() {
        let lastViewController = getLastViewController(with: .modal) ?? CoViApplication.getNavigationController()
        removeViewsToStackFromPresentModal(lastViewController)
    }

}
