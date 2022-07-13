//
//  BindableType.swift
//  CoVi
//
//  Created by Jorge Guilabert Ibáñez on 21/08/2019.
//  Copyright © 2019 Babel SI. All rights reserved.
//
#if os(iOS)
import UIKit
#elseif os(watchOS)
import WatchKit
#endif

public protocol BindableType {
    associatedtype ViewModelType

    var presenter: ViewModelType! { get set }
    func setupUI()
}

#if os(iOS)
extension BindableType where Self: UIViewController {

    /**
     Bind the presenter in the UIViewController.
     */
    public mutating func bind(to presenter: Self.ViewModelType) {
        self.presenter = presenter
        loadViewIfNeeded()
        setupUI()
    }

}

extension BindableType where Self: UIView {

    /**
     Bind the presenter in the UIView.
     */
    public mutating func bind(to presenter: Self.ViewModelType) {
        self.presenter = presenter
        setupUI()
    }

}

extension BindableType where Self: UITableViewCell {

    /**
     Bind the presenter in the UITableViewCell.
     */
    public mutating func bind(to presenter: Self.ViewModelType) {
        self.presenter = presenter
        setupUI()
    }

}

extension BindableType where Self: UICollectionViewCell {

    /**
     Bind the presenter in the UICollectionViewCell.
     */
    mutating func bind(to presenter: Self.ViewModelType) {
        self.presenter = presenter
        setupUI()
    }

}

#elseif os(watchOS)
extension BindableType where Self: WKInterfaceController {

    /**
     Bind the presenter in the UIViewController.
     */
    public mutating func bind(to presenter: Self.ViewModelType) {
        self.presenter = presenter
        setupUI()
    }

}
#endif
