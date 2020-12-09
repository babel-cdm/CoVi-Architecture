//
//  CoViWireframe.swift
//  CoVi
//
//  Created by Jorge Guilabert Ibáñez on 19/07/2019.
//  Copyright © 2019 Babel SI. All rights reserved.
//

import UIKit

private enum RouteTransitionType {
    case root
    case push
    case pushModal
    case modal
}

public protocol CoViWireframeProtocol: class {
    func popToRoot(animated: Bool)
    func pop(animated: Bool)
    func popModalToRoot(animated: Bool)
    func popModal(animated: Bool)
    func dismissModal(animated: Bool, completion: (() -> Void)?)
    func popGesture()
    func dismissGesture()
}

/**
 CoVi base wireframe.
 */
open class CoViWireframe {

    // MARK: - Properties

    /// Stack of views that exist in the application.
    public static var routerStack: [Any] { stack }
    private static var stack: [[UIViewController: RouteTransitionType]] = []

    // MARK: - Initializer

    public init() {}

    // MARK: - Private functions

    private func getLastNavigationController() -> UINavigationController? {
        var navigationController: UINavigationController?

        for router in CoViWireframe.stack.reversed() {
            if let navController = router.keys.first as? UINavigationController {
                navigationController = navController
                break
            }
        }

        return navigationController
    }

    private func getLastViewController(with routeTransitionType: RouteTransitionType? = nil) -> UIViewController? {
        var viewController: UIViewController?

        for router in CoViWireframe.stack.reversed() {
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

    private func getLastPushTransitionIndex() -> Int? {
        for (index, router) in CoViWireframe.stack.reversed().enumerated() {
            if let transitionType = router.values.first {
                if transitionType == .push || transitionType == .pushModal {
                    return (CoViWireframe.stack.count - 1) - index
                }
            }
        }
        return nil
    }

    private func getTotalPushViewsFromLastNavController() -> Int {
        var totaViewControllers = 0

        for router in CoViWireframe.stack.reversed() {
            if let transitionType = router.values.first {
                if transitionType == .push || transitionType == .pushModal {
                    totaViewControllers += 1
                } else if transitionType == .root {
                    break
                }
            }
        }

        return totaViewControllers
    }

    private func isViewInStack(_ view: UIViewController) -> Bool {
        var isInStack = false

        for router in CoViWireframe.stack {
            if router.keys.first == view {
                isInStack = true
                break
            }
        }

        return isInStack
    }

    private func addViewToStack(_ view: UIViewController, _ routeTransitionType: RouteTransitionType) {
        if !isViewInStack(view) {
            if (routeTransitionType == .push || routeTransitionType == .pushModal),
               let pushIndex = getLastPushTransitionIndex() {
                CoViWireframe.stack.insert([view: routeTransitionType], at: pushIndex + 1)
            } else {
                CoViWireframe.stack.append([view: routeTransitionType])
            }
        }
    }

    private func removeViewsToStackFromPushRoot(_ view: UIViewController) {
        for routerEnumerated in CoViWireframe.stack.enumerated() {
            if view == routerEnumerated.element.keys.first {
                let lastIndex = CoViWireframe.stack.count - 1

                /** position "0" is root
                 position "1" is the root VC
                 position "2" is the VC from which we want to remove
                 */
                let nextVcRootIndex = routerEnumerated.offset + 2 // +2 for the reason explained above

                if nextVcRootIndex <= lastIndex {
                    CoViWireframe.stack.removeSubrange(nextVcRootIndex...lastIndex)
                }
                break
            }
        }
    }

    private func removeViewsToStackFromPresentModal(_ view: UIViewController) {
        for routerEnumerated in CoViWireframe.stack.enumerated() {
            if view == routerEnumerated.element.keys.first {
                CoViWireframe.stack.removeSubrange(routerEnumerated.offset...CoViWireframe.stack.count - 1)

                if CoViWireframe.stack.last?.values.first == .root {
                    CoViWireframe.stack.removeLast()
                }
                break
            }
        }
    }

    // MARK: - Public functions

    /**
     Get the ViewController instance from a name/storyboard.

     - Parameter name: Storyboard's name.
     - Parameter bundle: Project's Bundle. Default is nil.
     */
    public func getViewFromStoryboard(name: String, bundle: Bundle? = nil) -> UIViewController {
        let storyboard: UIStoryboard = UIStoryboard(name: name, bundle: bundle)
        return storyboard.instantiateViewController(withIdentifier: name)
    }

    /**
    Get the ViewController instance from a name/xib.

    - Parameter name: Xib's name. Default is ViewController.self.
    - Parameter bundle: Project's Bundle. Default is nil.
    */
    public func getViewFromXib<View: UIViewController>(name: String = String(describing: View.self), bundle: Bundle? = nil) -> View {
        return View(nibName: name, bundle: bundle)
    }

    /**
     Push a new ViewController as 'Root' in the Window.

     - Parameters:
        - view: New ViewController.
        - animated: Boolean that decides if the transition is animated. By default is true.
     */
    public func pushRoot(view: UIViewController, animated: Bool = true) {
        let navigationController = CoViApplication.getNavigationController(rootVC: view)
        navigationController.pushRootViewController(animated: animated)

        CoViWireframe.stack.removeAll()
        addViewToStack(navigationController, .root)
        addViewToStack(view, .push)
    }

    /**
     Push a new ViewController in the stack.

     - Parameters:
        - view: New ViewController.
        - animated: Boolean that decides if the transition is animated. By default is true.
     */
    public func push(view: UIViewController, animated: Bool = true) {
        let navigationController = getLastNavigationController() ?? CoViApplication.getNavigationController()
        navigationController.pushViewController(view, animated: animated)

        addViewToStack(navigationController, .root)
        addViewToStack(view, .push)
    }

    /**
     Push a new ViewController in the stack as 'modal' transition.

     - Parameters:
        - view: New ViewController.
        - animated: Boolean that decides if the transition is animated. By default is true.
     */
    public func pushModal(view: UIViewController, animated: Bool = true) {
        let navigationController = getLastNavigationController() ?? CoViApplication.getNavigationController()
        navigationController.pushModalViewController(view, animated: animated)

        addViewToStack(navigationController, .root)
        addViewToStack(view, .pushModal)
    }

    /**
     Present a new ViewController as modal.

     - Parameters:
        - view: New ViewController.
        - animated: Boolean that decides if the transition is animated. By default is true.
     */
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

    /**
     Pop from current ViewController to root ViewController.

     - Parameters:
        - animated: Boolean that decides if the transition is animated. By default is true.
     */
    public func popToRoot(animated: Bool = true) {
        let navigationController = getLastNavigationController() ?? CoViApplication.getNavigationController()
        navigationController.popToRootViewController(animated: animated)

        removeViewsToStackFromPushRoot(navigationController)
    }

    /**
     Pop the current ViewController.

     - Parameters:
        - animated: Boolean that decides if the transition is animated. By default is true.
     */
    public func pop(animated: Bool = true) {
        let navigationController = getLastNavigationController() ?? CoViApplication.getNavigationController()
        navigationController.popViewController(animated: animated)

        popGesture()
    }

    /**
     Pop from current ViewController to root ViewController as 'modal' transition.

     - Parameters:
        - animated: Boolean that decides if the transition is animated. By default is true.
     */
    public func popModalToRoot(animated: Bool = true) {
        let navigationController = getLastNavigationController() ?? CoViApplication.getNavigationController()
        navigationController.popModalViewController(toRootVc: true, animated: animated)

        removeViewsToStackFromPushRoot(navigationController)
    }

    /**
     Pop the current ViewController as 'modal' transition.

     - Parameters:
        - animated: Boolean that decides if the transition is animated. By default is true.
     */
    public func popModal(animated: Bool = true) {
        let navigationController = getLastNavigationController() ?? CoViApplication.getNavigationController()
        navigationController.popModalViewController(animated: animated)

        popGesture()
    }

    /**
     Dismiss the current ViewController as modal.

     - Parameters:
        - animated: Boolean that decides if the transition is animated. By default is true.
        - completion: Completion handler to know when the dismiss has finished.
     */
    public func dismissModal(animated: Bool = true, completion: (() -> Void)? = nil) {
        let lastViewController = getLastViewController(with: .modal) ?? CoViApplication.getNavigationController()
        lastViewController.dismiss(animated: animated, completion: completion)

        removeViewsToStackFromPresentModal(lastViewController)
    }

    /// Pop the current ViewController when gesture has finished.
    public func popGesture() {
        if getTotalPushViewsFromLastNavController() > 1,
           let pushIndex = getLastPushTransitionIndex() {
            CoViWireframe.stack.remove(at: pushIndex)
        }
    }

    /// Dismiss the current ViewController when gesture has finished.
    public func dismissGesture() {
        let lastViewController = getLastViewController(with: .modal) ?? CoViApplication.getNavigationController()
        removeViewsToStackFromPresentModal(lastViewController)
    }

}
