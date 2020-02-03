//
//  CoViViewExtensions.swift
//  CoVi
//
//  Created by Jorge Guilabert Ibáñez on 21/08/2019.
//  Copyright © 2019 Babel SI. All rights reserved.
//

import UIKit

extension UIView {

    public static var identifier: String {
        return String(describing: self)
    }

    public static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    public func setShadow(shadowColor: UIColor = UIColor.black,
                          shadowRadius: CGFloat = 5,
                          shadowOpacity: Float = 0.2) {
        layer.shadowColor = shadowColor.cgColor
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = CGSize(width: 0, height: 0)
    }

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

    public func setCorners(corners: UIRectCorner? = nil,
                           bounds: CGRect? = nil,
                           radius: CGFloat? = nil,
                           borderColor: UIColor? = nil,
                           borderWidth: CGFloat = 1.0) {
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

        if let borderColor = borderColor {
            layer.borderColor = borderColor.cgColor
            layer.borderWidth = borderWidth
        }
    }

    public enum ConstraintType {
        case container
        case center
    }

    public func addSubview(childView: UIView, constraintType: ConstraintType) {
        addSubview(childView)
        switch constraintType {
        case .container:
            addContainerConstraints(childView: childView)
        case .center:
            addCenterConstraints(childView: childView)
        }
    }

    public func insertSubview(childView: UIView, belowSubview: UIView, constraintType: ConstraintType) {
        insertSubview(childView, belowSubview: belowSubview)
        switch constraintType {
        case .container:
            addContainerConstraints(childView: childView)
        case .center:
            addCenterConstraints(childView: childView)
        }
    }

    public func addContainerConstraints(childView: UIView) {
        // Adding Constraints to the superview
        childView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: childView, attribute: .top, relatedBy: .equal,
                                               toItem: self, attribute: .top,
                                               multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: childView, attribute: .bottom, relatedBy: .equal,
                                                  toItem: self, attribute: .bottom,
                                                  multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: childView, attribute: .leading, relatedBy: .equal,
                                                   toItem: self, attribute: .leading,
                                                   multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: childView, attribute: .trailing, relatedBy: .equal,
                                                    toItem: self, attribute: .trailing,
                                                    multiplier: 1, constant: 0)

        addConstraints([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
    }

    public func addCenterConstraints(childView: UIView) {
        // Adding Constraints to the superview
        childView.translatesAutoresizingMaskIntoConstraints = false
        let centerHorConstraint = NSLayoutConstraint(item: childView, attribute: .centerX, relatedBy: .equal,
                                                     toItem: self, attribute: .centerX,
                                                     multiplier: 1, constant: 0)
        let centerVerConstraint = NSLayoutConstraint(item: childView, attribute: .centerY, relatedBy: .equal,
                                                     toItem: self, attribute: .centerY,
                                                     multiplier: 1, constant: 0)

        addConstraints([centerHorConstraint, centerVerConstraint])
    }

}

extension UIScrollView {

    /// Decreases the content size of ScrollView so that when you exit the keyboard, do not hide any field of view.

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

    /// Get the name of the View Controller.

    public static var identifier: String {
        return String(describing: self)
    }

    /// Add gesture to hide keyboard when user taps outside keyboard.

    public func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    /// Hide keyboard.

    @objc open func dismissKeyboard() {
        view.endEditing(true)
    }

    public func add(childViewController: UIViewController, viewContainer: UIView) {
        addChild(childViewController)
        viewContainer.addSubview(childView: childViewController.view, constraintType: .container)
        childViewController.didMove(toParent: self)
    }

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

     - parameter image: Image to display in the back button.
     */
    public func setNavBarBackButtonImageApp(image: UIImage?) {
        if let backButtonImage = image {
            let barAppearance = UINavigationBar.appearance()
            barAppearance.backIndicatorImage = backButtonImage
            barAppearance.backIndicatorTransitionMaskImage = backButtonImage
        }
    }

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
