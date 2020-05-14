//
//  CoViCollectionView.swift
//  CoVi
//
//  Created by Alvaro Garcia on 14/05/2020.
//  Copyright © 2020 Babel SI. All rights reserved.
//

import UIKit

/**
 CoVi base collection view.
 */
open class CoViCollectionView: UICollectionView, UICollectionViewDataSource {

    public typealias CellConfigurator = (UICollectionView, IndexPath) -> UICollectionViewCell

    // MARK: - Properties

    private var collectionViewDataSource: CoViCollectionViewDataSource?
    private var customUICollectionViewDelegate: CoViCollectionViewDelegateImpl?
    private var customUICollectionViewDelegateFlowLayout: CoViCollectionViewDelegateFlowLayoutImpl?
    private var cellForRowAtConfigurator: CellConfigurator?

    // MARK: - Functions

    public func setupDataSource(_ dataSource: CoViCollectionViewDataSource?) {
        self.dataSource = self
        self.collectionViewDataSource = dataSource
    }

    public func setupDelegate(_ delegate: CoViCollectionViewDelegate?) {
        if self.delegate == nil || self.delegate is CoViCollectionViewDelegateImpl {
            self.customUICollectionViewDelegate = delegate == nil ? nil : CoViCollectionViewDelegateImpl(delegate)
            self.delegate = customUICollectionViewDelegate
        }
    }

    public func setupDelegate(_ delegate: CoViCollectionViewDelegateImpl?) {
        if self.delegate == nil || self.delegate is CoViCollectionViewDelegateImpl {
            self.customUICollectionViewDelegate = delegate
            self.delegate = customUICollectionViewDelegate
        }
    }

    public func setupDelegateFlowLayout(_ delegate: CoViCollectionViewDelegateFlowLayout?) {
        self.customUICollectionViewDelegateFlowLayout = delegate == nil ? nil : CoViCollectionViewDelegateFlowLayoutImpl(delegate)
        self.delegate = customUICollectionViewDelegateFlowLayout
    }

    public func setupDelegateFlowLayout(_ delegate: CoViCollectionViewDelegateFlowLayoutImpl?) {
        self.customUICollectionViewDelegateFlowLayout = delegate
        self.delegate = customUICollectionViewDelegateFlowLayout
    }

    open func reloadData(cellForRowAtConfigurator: @escaping CellConfigurator) {
        self.cellForRowAtConfigurator = cellForRowAtConfigurator

        self.reloadData()
    }

    // MARK: - UICollectionViewDataSource

    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionViewDataSource?.numberOfItemsInSection(collectionView.tag, section) ?? 0
    }

    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let numberOfSections = collectionViewDataSource?.numberOfSections {
            return numberOfSections(collectionView.tag)
        }
        return 1
    }

    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell
        if let cellForRowAtConfigurator = cellForRowAtConfigurator {
            cell = cellForRowAtConfigurator(collectionView, indexPath)
        } else {
            cell = UICollectionViewCell()
        }
        return cell
    }

}
