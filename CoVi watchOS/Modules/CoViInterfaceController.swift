//
//  CoViInterfaceController.swift
//  CoVi
//
//  Created by alvaro.grimal.local on 1/7/22.
//  Copyright © 2022 Babel SI. All rights reserved.
//

import WatchKit

public protocol CoViViewProtocol: AnyObject {}

typealias CoViInterfaceProtocol = CoViViewProtocol

private protocol CoViInterfaceDependencies: AnyObject {
    associatedtype Presenter

    func getPresenter() -> Presenter?
}

/**
 CoVi base interfaceController.
 This InterfaceController extends of BindableType.

 - BindableType is required to facilitate the presenter's bind at the view.

 # Generic Parameters
 - Presenter: Presenter protocol parameter.
 */
open class CoViInterfaceController<Presenter>: WKInterfaceController,
                                               CoViInterfaceDependencies,
                                               BindableType {

    // MARK: - VIPER Dependencies

    public var presenter: CoViPresenterProtocol!

    /**
     Obtain the presenter protocol casted to 'Presenter' type.
     */
    public func getPresenter() -> Presenter? {
        return presenter as? Presenter
    }


    // MARK: - Lifecycle
    
    open override func willActivate() {
        super.willActivate()
        presenter.willActivate()
    }
    
    open override func didDeactivate() {
        super.didDeactivate()
        presenter.didDeactivate()
    }
    
    open override func willDisappear() {
        super.willDisappear()
        presenter.willDisappear()
    }
    
    open override func didAppear() {
        super.didAppear()
        presenter.didAppear()
    }

    // MARK: - BindableType

    /**
     Override this function to setup the UI.
     */
    open func setupUI() {}

}
