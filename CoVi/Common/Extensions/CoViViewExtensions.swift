//
//  CoViViewExtensions.swift
//  CoVi
//
//  Created by Jorge Guilabert Ibáñez on 21/08/2019.
//  Copyright © 2019 Babel SI. All rights reserved.
//

import UIKit

extension UIView {

    /// Get the file name of the View.
    public static var identifier: String {
        return String(describing: self)
    }

    /// Get the Nib instance from the file name.
    public static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    /**
     Add a shadow to the view.

     - Parameters:
        - shadowColor: Color of the shadow. By default is 'black'.
        - shadowRadius: Radius of the shadow. By default is 5.
        - shadowOpacity: Transparency of the shadow. By default is 0.2.
     */
    public func setShadow(shadowColor: UIColor = UIColor.black,
                          shadowRadius: CGFloat = 5,
                          shadowOpacity: Float = 0.2) {
        layer.shadowColor = shadowColor.cgColor
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = CGSize(width: 0, height: 0)
    }

    /**
     Add a shadow to the view.

     - Parameters:
        - side: Side where you want the shadow to stick out.
        - shadowOffset: Offset you want the shadow to stick out. By default is 3.
        - shadowColor: Color of the shadow. By default is 'black'.
        - shadowRadius: Radius of the shadow. By default is 5.
        - shadowOpacity: Transparency of the shadow. By default is 0.2.
     */
    public func setShadow(side: CoViViewConstants.Sides,
                          shadowOffset: CGFloat = 3,
                          shadowColor: UIColor = UIColor.black,
                          shadowRadius: CGFloat = 5,
                          shadowOpacity: Float = 0.2) {
        setShadow(shadowColor: shadowColor, shadowRadius: shadowRadius, shadowOpacity: shadowOpacity)

        switch side {
        case .top:
            layer.shadowOffset = CGSize(width: 0, height: -(shadowOffset))
        case .bottom:
            layer.shadowOffset = CGSize(width: 0, height: shadowOffset)
        case .right:
            layer.shadowOffset = CGSize(width: shadowOffset, height: 0)
        case .left:
            layer.shadowOffset = CGSize(width: -(shadowOffset), height: 0)
        }
    }

    /**
     Add curved corners to the view.

     - Parameters:
        - corners: Sides where you want to add a curved corner. By default are all corners.
        - bounds: CGRect of the shadow. Only is used if the corners parameter is set. By default is 'self.bounds'.
        - radius: Corner radius. If corners parameter is set, by default is 13; if it is not set, by default is 'layer.frame.height / 2'.
     */
    public func setCorners(corners: UIRectCorner? = nil,
                           bounds: CGRect? = nil,
                           radius: CGFloat? = nil) {
        if let corners = corners {
            let path: UIBezierPath!
            var width = 13
            var height = 13
            var rect = self.bounds

            if let bounds = bounds {
                rect = bounds
            }

            if let radius = radius {
                width = Int(radius)
                height = Int(radius)
            }

            path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: width, height: height))

            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath

            layer.mask = maskLayer
        } else {
            if let radius = radius {
                layer.cornerRadius = radius
            } else {
                layer.cornerRadius = layer.frame.height / 2
            }
        }
    }

    /**
     Add a border color and width to the view.

     - Parameters:
        - borderColor: Border color.
        - borderWidth: Border width. By default is 1.
     */
    public func setBorder(borderColor: UIColor, borderWidth: CGFloat = 1.0) {
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
    }

    public enum ConstraintType {
        case container
        case center
    }

    /**
     Add a subview in other view.

     - Parameters:
        - childView: The view you want to add in another view.
        - constraintType: Enumerated that decides how to add the view.
     */
    public func addSubview(childView: UIView, constraintType: ConstraintType) {
        addSubview(childView)
        addConstraints(childView: childView, constraintType: constraintType)
    }

    /**
     Insert a subview above another view.

     - Parameters:
        - childView: The view you want to add in another view.
        - aboveSubview: View that will be below the 'childView'.
        - constraintType: Enumerated that decides how to add the view.
     */
    public func insertSubview(childView: UIView, aboveSubview: UIView, constraintType: ConstraintType) {
        insertSubview(childView, aboveSubview: aboveSubview)
        addConstraints(childView: childView, constraintType: constraintType)
    }

    /**
     Insert a subview below another view.

     - Parameters:
        - childView: The view you want to add in another view.
        - belowSubview: View that will be above the 'childView'.
        - constraintType: Enumerated that decides how to add the view.
     */
    public func insertSubview(childView: UIView, belowSubview: UIView, constraintType: ConstraintType) {
        insertSubview(childView, belowSubview: belowSubview)
        addConstraints(childView: childView, constraintType: constraintType)
    }

    /**
     Insert a subview within another view, in a particular position.

     - Parameters:
        - childView: The view you want to add in another view.
        - position: Position where you want to insert the new view.
        - constraintType: Enumerated that decides how to add the view.
     */
    public func insertSubview(childView: UIView, at position: Int, constraintType: ConstraintType) {
        insertSubview(childView, at: position)
        addConstraints(childView: childView, constraintType: constraintType)
    }

    private func addConstraints(childView: UIView, constraintType: ConstraintType) {
        childView.translatesAutoresizingMaskIntoConstraints = false
        switch constraintType {
        case .container:
            addContainerConstraints(childView: childView)
        case .center:
            addCenterConstraints(childView: childView)
        }
    }

    /**
     Add contraints to match the parent's measurements.

     - Parameter childView: The view to which you want to add the constraints.
     */
    public func addContainerConstraints(childView: UIView) {
        let constraints = CoViViewUtils.getContainerConstraints(item: childView, toItem: self)
        addConstraints(constraints)
    }

    /**
     Add constraints to center on the parent.

     - Parameter childView: The view to which you want to add the constraints.
     */
    public func addCenterConstraints(childView: UIView) {
        let constraints = CoViViewUtils.getCenterConstraints(item: childView, toItem: self)
        addConstraints(constraints)
    }

}

extension UIScrollView {

    /**
     Decreases the content size of ScrollView so that when you exit the keyboard, do not hide any field of view.

     - Parameter notification: Notification that the size of the keyboard has changed.
     */
    public func setScrollSizeOnKeyboard(notification: NSNotification) {
        guard let info = notification.userInfo,
            let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size else {
            print("Error: No size for keyboard in info")
            return
        }

        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        self.contentInset = contentInsets
        self.scrollIndicatorInsets = contentInsets
    }

    /// Resets the content size of ScrollView when the keyboard is hidden.
    public func resetScrollSizeOnKeyboard() {
        let contentInsets = UIEdgeInsets.zero
        self.contentInset = contentInsets
        self.scrollIndicatorInsets = contentInsets
    }
}

extension UIViewController {

    /// Boolean that decides whether to add a scrollView in the view, so that the whole view is scrollable.
    @objc open var hasBaseVerticalScrollView: Bool {
        return false
    }

    /// Get the file name of the View Controller.
    public static var identifier: String {
        return String(describing: self)
    }

    /// Add gesture to hide keyboard when user taps outside keyboard.
    public func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    /// Check if `hasBaseVerticalScrollView` is enabled, to add the ScrollView as main view of the ViewController.
    public func checkBaseVerticalScrollView() {
        if hasBaseVerticalScrollView {
            let scrollView = UIScrollView()
            let contentView: UIView = view
            scrollView.addSubview(contentView)

            contentView.translatesAutoresizingMaskIntoConstraints = false
            var scrollViewConstraints = CoViViewUtils.getContainerConstraints(item: contentView,
                                                                              toItem: scrollView.contentLayoutGuide)
            let widthConstraint = NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal,
                                                     toItem: scrollView.frameLayoutGuide, attribute: .width,
                                                     multiplier: 1, constant: 0)
            scrollViewConstraints.append(widthConstraint)

            scrollView.addConstraints(scrollViewConstraints)

            view = scrollView
        }
    }

    /// Hide keyboard.
    @objc open func dismissKeyboard() {
        view.endEditing(true)
    }

    /**
     Add a ViewController inside a view container. This function adds contraints too.

     - Parameters:
        - childViewController: ViewController that you want to add to the container.
        - viewContainer: Container view.
     */
    public func add(childViewController: UIViewController, viewContainer: UIView) {
        addChild(childViewController)
        viewContainer.addSubview(childView: childViewController.view, constraintType: .container)
        childViewController.didMove(toParent: self)
    }

    /// Remove a ViewController from its container.
    public func remove() {
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }

}

extension UINavigationController {

    /**
     Set the NavigationBar back button image.

     If the image of the back button is changed, it will be changed for the entire application.
     If you want to change only on one screen, it's recommended to use the *setNavBarButtons(backImage: "")* function.

     - Parameter image: Image to display in the back button.
     */
    public func setNavBarBackButtonImageApp(image: UIImage?) {
        if let backButtonImage = image {
            let barAppearance = UINavigationBar.appearance()
            barAppearance.backIndicatorImage = backButtonImage
            barAppearance.backIndicatorTransitionMaskImage = backButtonImage
        }
    }

    /**
     Push the NavigationController as 'Root' in the `Window`.

     - Parameter animated: Boolean who decides whether to animate the transition with the effect *.transitionCrossDissolve*.
     */
    func pushRootViewController(animated: Bool) {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }

        window.rootViewController = self

        if animated {
            UIView.transition(with: window,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
        }
    }

    /**
     Push a ViewController as 'modal' transition.

     - Parameter view: New ViewController to push.
     - Parameter animated: Boolean who decides whether to animate the transition with 'modal' efect.
     */
    func pushModalViewController(_ view: UIViewController, animated: Bool) {
        var isAnimated = animated
        if animated {
            let transition = CATransition()
            transition.duration = 0.4
            transition.type = CATransitionType.moveIn
            transition.subtype = CATransitionSubtype.fromTop
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            self.view.layer.add(transition, forKey: kCATransition)

            isAnimated = false
        }

        pushViewController(view, animated: isAnimated)
    }

    /**
     Pop the ViewController as 'modal' transition.

     - Parameter toRootVc: If true, return to the Root View Controller. By default is false.
     - Parameter animated: Boolean who decides whether to animate the transition with 'modal' efect.
     */
    func popModalViewController(toRootVc: Bool = false, animated: Bool) {
        var isAnimated = animated
        if animated {
            let transition = CATransition()
            transition.duration = 0.4
            transition.type = CATransitionType.reveal
            transition.subtype = CATransitionSubtype.fromBottom
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            self.view.layer.add(transition, forKey: kCATransition)

            isAnimated = false
        }

        if toRootVc {
            popToRootViewController(animated: isAnimated)
        } else {
            popViewController(animated: isAnimated)
        }
    }

}
