//
//  CoViPresenter.swift
//  CoVi
//
//  Created by Jorge Guilabert Ibáñez on 19/07/2019.
//  Copyright © 2019 Babel SI. All rights reserved.
//

import Foundation

public protocol CoViPresenterProtocol: class {
    func didLoad()
    func willAppear()
    func didAppear()
    func willDisappear()
    func didDisappear()
    func onNavBarLeftButtonClicked()
    func onNavBarRightButtonClicked(_ tag: Int)
    func handlePopBeganGesture()
    func handlePopEndedGesture()
    func handleDismissEndedGesture()
}

private protocol CoViPresenterDependencies: class {
    associatedtype View
    associatedtype Router

    func getView() -> View?
    func getRouter() -> Router?
}

open class CoViPresenter<View, Router>: CoViPresenterDependencies {

    // MARK: - Properties

    public var coviDisposeBag: CoViDisposeBag

    // MARK: - VIPER Dependencies

    weak var view: CoViViewProtocol?
    let router: CoViWireframeProtocol

    public func getView() -> View? {
        return view as? View
    }

    public func getRouter() -> Router? {
        return router as? Router
    }

    // MARK: - Initializer

    public init(view: CoViViewProtocol, router: CoViWireframeProtocol) {
        self.coviDisposeBag = CoViDisposeBag()
        self.view = view
        self.router = router
    }

    deinit {
        NotificationCenter.default.post(name: disposeBagNotificationId,
                                        object: nil,
                                        userInfo: [disposeBagNotificationParameter: coviDisposeBag])
    }

    // MARK: - CoViPresenterProtocol

    open func didLoad() {}

    open func willAppear() {}

    open func didAppear() {}

    open func willDisappear() {}

    open func didDisappear() {}

    open func onNavBarLeftButtonClicked() {
        router.pop(animated: true)
    }

    open func onNavBarRightButtonClicked(_ tag: Int) {}

    open func handlePopBeganGesture() {}

    open func handlePopEndedGesture() {
        router.popGesture()
    }

    open func handleDismissEndedGesture() {
        router.dismissGesture()
    }

}
