//
//  CoViCollectionViewDelegate.swift
//  CoVi
//
//  Created by Alvaro Garcia on 11/05/2020.
//  Copyright © 2020 Babel. All rights reserved.
//

/**
 CoVi base table view delegate.
 */
@objc public protocol CoViCollectionViewDelegate: CoViScrollViewDelegate {
    @objc optional func didSelectItemAt(_ collectionViewTag: Int, _ indexPath: IndexPath)
    @objc optional func didDeselectRowAt(_ collectionViewTag: Int, _ indexPath: IndexPath)
    @objc optional func willDisplay(_ collectionViewTag: Int, _ indexPath: IndexPath)
    @objc optional func shouldHighlightRowAt(_ collectionViewTag: Int, _ indexPath: IndexPath) -> Bool
    @objc optional func didHighlightRowAt(_ collectionViewTag: Int, _ indexPath: IndexPath)
    @objc optional func didUnhighlightRowAt(_ collectionViewTag: Int, _ indexPath: IndexPath)
}
