//
//  CoViPresenter.swift
//  CoVi
//
//  Created by Jorge Guilabert Ibáñez on 19/07/2019.
//  Copyright © 2019 Babel SI. All rights reserved.
//

import Foundation

public protocol CoViPresenterProtocol: AnyObject {
    func didLoad()
    func willAppear()
    func didAppear()
    func willDisappear()
    func didDisappear()
    func willActivate()
    func didDeactivate()
    func onNavBarLeftButtonClicked()
    func onNavBarRightButtonClicked(_ tag: Int)
    func handlePopBeganGesture()
    func handlePopEndedGesture()
    func handleDismissEndedGesture()
}

private protocol CoViPresenterDependencies: AnyObject {
    associatedtype View
    associatedtype Router

    func getView() -> View?
    func getRouter() -> Router?
}

/**
 CoVi base presenter.

 # Generic Parameters
 - View: View protocol parameter.
 - Router: Router protocol parameter.
 */
open class CoViPresenter<View, Router>: CoViPresenterDependencies {

    // MARK: - Properties

    /**
     DisposeBag to use in the interactors.
     It is required for the interactor to know when the Presenter disinstates.
     */
    public var coviDisposeBag: CoViDisposeBag

    // MARK: - VIPER Dependencies

    weak var view: CoViViewProtocol?
    let router: CoViWireframeProtocol

    /**
     Obtain the view protocol casted to 'View' type.
     */
    public func getView() -> View? {
        return view as? View
    }

    /**
     Obtain the router protocol casted to 'Router' type.
     */
    public func getRouter() -> Router? {
        return router as? Router
    }

    // MARK: - Initializer

    /**
     Initializer of DisposeBag, 'View' and 'Router'
     */
    public init(view: CoViViewProtocol, router: CoViWireframeProtocol) {
        self.coviDisposeBag = CoViDisposeBag()
        self.view = view
        self.router = router
    }

    /**
     Deinit method that sends a notification to Interactor, warning that the Presenter is going to disinstantiate.
     */
    deinit {
        NotificationCenter.default.post(name: disposeBagNotificationId,
                                        object: nil,
                                        userInfo: [disposeBagNotificationParameter: coviDisposeBag])
    }

    // MARK: - CoViPresenterProtocol

    /**
     Called when `viewDidLoad()` function of ViewController is called.
     */
    open func didLoad() {}

    /**
     Called when `viewWillAppear(_:)` function of ViewController is called.
     */
    open func willAppear() {}

    /**
     Called when `viewDidAppear(_:)` functions from ViewController and WKInterfaceController are called.
     */
    open func didAppear() {}

    /**
     Called when `viewWillDisappear(_:)` functions from ViewController and WKInterfaceController are called.
     */
    open func willDisappear() {}

    /**
     Called when `viewDidDisappear(_:)` function of ViewController is called.
     */
    open func didDisappear() {}
    
#if os(iOS)
    /**
     Called when the left button of NavigationController is clicked.
     By default, this function go back in the Router.
     */
    open func onNavBarLeftButtonClicked() {
        router.pop(animated: true)
    }
    
    /**
     Called when the user finishes the "pop" closing gesture.
     */
    open func handlePopEndedGesture() {
        router.popGesture()
    }
    
    /**
     Called when the user finishes the "dismiss" closing gesture.
     */
    open func handleDismissEndedGesture() {
        router.dismissGesture()
    }
    
#endif
    /**
     Called when the right buttons of NavigationController are clicked.

     - Parameter tag: This parameter is used to differentiate which button has been pressed.
     */
    open func onNavBarRightButtonClicked(_ tag: Int) {}

    /**
     Called when the user begins the "pop" closing gesture.
     */
    open func handlePopBeganGesture() {}

    /**
     Called when `willActivate()` function of WKInterfaceController is called.
     */
    open func willActivate() {}
    
    /**
     Called when `didDeactivate()` function of WKInterfaceController is called.
     */
    open func didDeactivate() {}

}
