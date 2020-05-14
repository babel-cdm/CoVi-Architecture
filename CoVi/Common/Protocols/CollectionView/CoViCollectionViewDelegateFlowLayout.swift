//
//  CoViCollectionViewDelegateFlowLayout.swift
//  CoVi
//
//  Created by Alvaro Garcia on 11/05/2020.
//  Copyright © 2020 Babel. All rights reserved.
//

/**
 CoVi base table view data source.
 */
@objc public protocol CoViCollectionViewDelegateFlowLayout: CoViCollectionViewDelegate {
    @objc optional func sizeForItem(_ collectionViewTag: Int, _ indexPath: IndexPath) -> CVSize
}
