//
//  CoViScrollViewDelegate.swift
//  CoVi
//
//  Created by Jorge Guilabert Ibáñez on 14/05/2020.
//  Copyright © 2020 Babel SI. All rights reserved.
//

/**
 CoVi base scroll view delegate.
 */
@objc public protocol CoViScrollViewDelegate: AnyObject {
    @objc optional func scrollViewDidScroll(_ scrollViewTag: Int)
    @objc optional func scrollViewDidChangeAdjustedContentInset(_ scrollViewTag: Int)
    @objc optional func scrollViewDidEndScrollingAnimation(_ scrollViewTag: Int)
    @objc optional func scrollViewWillBeginDecelerating(_ scrollViewTag: Int)
    @objc optional func scrollViewDidEndDecelerating(_ scrollViewTag: Int)
    @objc optional func scrollViewWillBeginDragging(_ scrollViewTag: Int)
}
