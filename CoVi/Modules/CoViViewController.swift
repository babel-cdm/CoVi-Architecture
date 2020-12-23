//
//  CoViViewController.swift
//  CoVi
//
//  Created by Jorge Guilabert Ibáñez on 19/07/2019.
//  Copyright © 2019 Babel SI. All rights reserved.
//

import UIKit

public protocol CoViViewProtocol: class {}

private protocol CoViViewDependencies: class {
    associatedtype Presenter

    func getPresenter() -> Presenter?
}

/**
 CoVi base viewController.
 This ViewController extends of BindableType, UIGestureRecognizerDelegate and UIAdaptivePresentationControllerDelegate.

 - BindableType is required to facilitate the presenter's bind at the view.
 - UIGestureRecognizerDelegate is used to recognize the user's 'pop' gesture.
 - UIAdaptivePresentationControllerDelegate is used to recognize the user's 'dismiss' gesture.

 # Generic Parameters
 - Presenter: Presenter protocol parameter.
 */
open class CoViViewController<Presenter>: UIViewController,
                                            CoViViewDependencies,
                                            BindableType,
                                            UIGestureRecognizerDelegate,
                                            UIAdaptivePresentationControllerDelegate {

    // MARK: - VIPER Dependencies

    public var presenter: CoViPresenterProtocol!

    /**
     Obtain the presenter protocol casted to 'Presenter' type.
     */
    public func getPresenter() -> Presenter? {
        return presenter as? Presenter
    }

    // MARK: - Properties

    private var backButtonImage: String = ""

    private var rootViewController: UIViewController {
        if let parent = parent as? UIPageViewController {
            return parent
        } else {
            return self
        }
    }

    // MARK: - Lifecycle

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if hasBaseVerticalScrollView {
            resizeBaseVerticalScrollViewIfNeeded()
        }
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        presenter.didLoad()

        hideKeyboardWhenTappedAround()
        checkBaseVerticalScrollView()
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.willAppear()

        // Add delegate to register the backward gesture
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        // Add listener to register the pop gesture
        navigationController?.interactivePopGestureRecognizer?.addTarget(self, action: #selector(handlePopGesture))

        /**
         Add listener to register the dismiss gesture.
         (Be careful, because writing ".presentedViewController" without being modal,
         causes memory leak with iOS <= 13.5)
         */
        if let navigationController = navigationController, let modalViewController = navigationController.presentedViewController {
            // If the modal is presented by NavigationController.
            modalViewController.presentationController?.delegate = self
        } else if self.presentingViewController != nil {
            // If the modal is presented by ViewController.
            self.presentationController?.delegate = self
        }
    }

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.didAppear()
    }

    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.willDisappear()

        // Remove listener to register the pop gesture
        navigationController?.interactivePopGestureRecognizer?.removeTarget(self, action: #selector(handlePopGesture))
    }

    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter.didDisappear()
    }

    // MARK: - BindableType

    /**
     Override this function to setup the UI.
     */
    open func setupUI() {}

    // MARK: - Native Alert

    /**
     Show a native alert.

     - parameter title: Title of the alert.
     - parameter message: Message to the alert.
     - parameter actions: Array of actions/buttons to be displayed in the alert.
     - parameter style: Style of presentation of the alert. By default is ".alert".
     */
    open func showNativeAlertView(title: String,
                                  message: String,
                                  actions: [UIAlertAction],
                                  style: UIAlertController.Style = .alert) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        for action in actions {
            alertController.addAction(action)
        }

        if style == .actionSheet, let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX,
                                                  y: self.view.bounds.midY,
                                                  width: 0,
                                                  height: 0)
            popoverController.permittedArrowDirections = []
        }

        present(alertController, animated: true, completion: nil)
    }

    // MARK: - Keyboard Notification (Show and Hide)

    /**
     Add keyboard observers to notify when the keyboard is displayed.
     To listen the notifications, its necessary override 'onKeyboardWasShown' and 'onKeyboardWillBeHidden' functions.
     */
    public func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWasShown),
                                               name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillBeHidden),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    /**
     Function triggered when the keyboard is displayed.

     - parameter notification: System notification.
     */
    @objc open func onKeyboardWasShown(_ notification: NSNotification) {
        // Overridden function
    }

    /**
     Function triggered when the keyboard is hidden.

     - parameter notification: System notification.
     */
    @objc open func onKeyboardWillBeHidden(_ notification: NSNotification) {
        // Overridden function
    }

    // MARK: - Navigation Bar

    /**
     Set the title on the NavigationBar.

     Use recommended in the viewDidLoad.

     - parameter title: Title displayed.
     */
    public func setNavBarTitleString(_ title: String?) {
        rootViewController.title = title
    }

    /**
     Set an image as a title on the NavigationBar.

     Use recommended in the viewDidLoad.

     - parameter image: Icon displayed.
     */
    public func setNavBarTitleImage(_ image: UIImage?) {
        if let image = image {
            setupNavBarTitleImage(image)
        }
    }

    /**
     Set an image as a title on the NavigationBar.

     Use recommended in the viewDidLoad.

     - parameter imageName: Image name of the icon displayed.
     */
    public func setNavBarTitleImage(_ imageName: String) {
        if let image = UIImage(named: imageName) {
            setupNavBarTitleImage(image)
        }
    }

    /**
     Set the title style on the NavigationBar.

     Use recommended in the viewDidLoad.

     - parameter textAttributes: Attributes of the title.
     */
    public func setNavBarTitleAttributes(textAttributes: [NSAttributedString.Key: Any]) {
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }

    /**
     Set the title style on the NavigationBar.

     Use recommended in the viewDidLoad.

     - parameter color: Color of the title.
     - parameter font: Font of the title.
     */
    public func setNavBarTitleAttributes(color: UIColor? = nil, font: UIFont? = nil) {
        var titleTextAttributes: [NSAttributedString.Key: Any] =
            [NSAttributedString.Key.foregroundColor: color ?? UIColor.black]
        if let font = font {
            titleTextAttributes[NSAttributedString.Key.font] = font
        }
        setNavBarTitleAttributes(textAttributes: titleTextAttributes)
    }

    /**
     Set visibility of the NavigationBar.

     **Use always in the viewWillAppear.**

     - parameter isHidden: If true, the NavigationBar is hidden.
     */
    public func setNavBarVisivility(isHidden: Bool) {
        navigationController?.setNavigationBarHidden(isHidden, animated: true)
    }

    /**
     Set visibility of the bottom line of the NavigationBar.

     **Use always in the viewWillAppear.**

     - parameter isHidden: If true, the bottom line of the NavigationBar is hidden.
     */
    public func setNavBarBottomLineVisivility(isHidden: Bool) {
        if isHidden {
            navigationController?.navigationBar.shadowImage = UIImage()
        } else {
            navigationController?.navigationBar.shadowImage = nil
        }
    }

    /**
     Set shadow on the NavigationBar.

     **Use always in the viewWillAppear.**

     - parameter hasShadow: If true, the NavigationBar will have a shadow.
     - parameter shadowColor: Color of the shadow. By default is black.
     */
    public func setNavBarShadow(hasShadow: Bool, shadowColor: UIColor = .black) {
        if hasShadow {
            navigationController?.navigationBar.setShadow(side: .bottom, shadowColor: shadowColor)
        } else {
            navigationController?.navigationBar.setShadow(side: .bottom, shadowColor: .clear)
        }
    }

    /**
     Set the NavigationBar back button visibility.

     Use recommended in the viewDidLoad.

     - parameter isHidden: If true, the NavigationBar won't have the back button.
     */
    public func setNavBarBackButtonVisibility(isHidden: Bool) {
        navigationItem.hidesBackButton = isHidden
    }

    /**
     Set the NavigationBar back title button.

     **It's necessary to set it on the current screen.**

     For example: Home -> Settings.
     You have to set the back title in the Home, so that "Home" does not appear in the Settings.

     Use recommended in the viewDidLoad.

     - parameter backTitle: Title to display in the back button. By default is empty.
     */
    public func setNavBarBackTitle(backTitle: String = "") {
        let navigationItem = rootViewController.navigationItem
        let backBarButtton = UIBarButtonItem(title: backTitle, style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtton
    }

    /**
     Set the NavigationBar buttons.

     Use recommended in the viewDidLoad.

     - parameter backImage: Image name used as an image to go back when
     you have more than one ViewController in the NavigationController.
     **This parameter is overridden by the *leftImage* parameter.**
     - parameter leftImage: Image name to be displayed to the left of the title of the NavigationBar.
     **This parameter override the *backImage* parameter.**
     - parameter rightImages: Array of image names to be displayed to the right of the title of the NavigationBar.
     */
    public func setNavBarButtons(backImage: String? = nil, leftImage: String? = nil, rightImages: [String]? = nil) {
        if let backImage = backImage {
            backButtonImage = backImage
        }

        let navigationItem = rootViewController.navigationItem
        navigationItem.leftBarButtonItems = getNavBarLeftButtons(leftImage)
        navigationItem.rightBarButtonItems = getNavBarRightButtons(rightImages)
    }

    private func setupNavBarTitleImage(_ image: UIImage, width: CGFloat = 150) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit

        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 44))
        imageView.frame = titleView.bounds
        titleView.addSubview(imageView)

        rootViewController.navigationItem.titleView = titleView
    }

    private func getNavBarViewControllerCount() -> Int {
        return navigationController?.viewControllers.count ?? 0
    }

    private func getNavBarLeftButtons(_ leftImage: String? = nil) -> [UIBarButtonItem] {

        var leftButtons: [UIBarButtonItem] = []
        var imageName = ""

        if let leftImage = leftImage {
            imageName = leftImage
        } else if getNavBarViewControllerCount() > 1 {
            imageName = backButtonImage
        }

        if !imageName.isEmpty {
            let leftItem = createBarButtonItem(image: imageName,
                                               function: #selector(onNavBarLeftButtonClicked),
                                               isLeftButton: true)
            leftButtons = [leftItem]
        }

        return leftButtons
    }

    private func getNavBarRightButtons(_ rightImages: [String]? = nil) -> [UIBarButtonItem] {

        if let rightImages = rightImages {
            return rightImages.enumerated().map {
                createBarButtonItem(image: $1,
                                    function: #selector(onNavBarRightButtonClicked),
                                    tag: $0)
            }
        } else {
            return []
        }
    }

    @objc private func onNavBarLeftButtonClicked(_ sender: UIBarButtonItem) {
        presenter.onNavBarLeftButtonClicked()
    }

    @objc private func onNavBarRightButtonClicked(_ sender: UIBarButtonItem) {
        presenter.onNavBarRightButtonClicked(sender.tag)
    }

    private func createBarButtonItem(image: String,
                                     function: Selector,
                                     tag: Int = 0,
                                     isLeftButton: Bool = false) -> UIBarButtonItem {

        let btnItem = UIButton()
        btnItem.imageEdgeInsets = UIEdgeInsets(top: 7, left: isLeftButton ? 0 : 7, bottom: 7, right: 7)
        btnItem.addTarget(self, action: function, for: .touchUpInside)
        btnItem.tag = tag

        if let image = UIImage(named: image) {
            btnItem.setImage(image, for: .normal)
        } else {
            btnItem.setTitle(image, for: .normal)
        }

        btnItem.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
        btnItem.heightAnchor.constraint(equalToConstant: 44.0).isActive = true

        return UIBarButtonItem(customView: btnItem)
    }

    private func resizeBaseVerticalScrollViewIfNeeded() {
        if let scrollView = view as? UIScrollView,
            scrollView.contentLayoutGuide.layoutFrame.height < scrollView.safeAreaLayoutGuide.layoutFrame.height &&
                scrollView.contentLayoutGuide.layoutFrame.height > 0 {
            let contentView = scrollView.subviews.first ?? scrollView
            let scrollViewConstraints = CoViViewUtils.getContainerConstraints(item: contentView,
                                                                              toItem: scrollView.safeAreaLayoutGuide)

            scrollView.constraints.forEach { constraint in
                if constraint.secondItem === scrollView.contentLayoutGuide {
                    scrollView.removeConstraint(constraint)
                }
            }
            scrollView.addConstraints(scrollViewConstraints)
        }
    }

    // MARK: - UIGestureRecognizerDelegate functions

    /// Delegate's event to decide if the viewController has 'pop' gesture.
    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return getNavBarViewControllerCount() > 1
    }

    /// Event associated with 'pop' gesture.
    @objc open func handlePopGesture(gesture: UIGestureRecognizer) {
        if gesture.state == .began {
            presenter.handlePopBeganGesture()
        } else if gesture.state == .ended {
            presenter.handlePopEndedGesture()
        }
    }

    // MARK: - UIAdaptivePresentationControllerDelegate functions

    /// Delegate's event associated with 'dismiss' gesture.
    open func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        presenter.handleDismissEndedGesture()
    }

}
