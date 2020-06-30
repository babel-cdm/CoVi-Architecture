//
//  CoViScrollView.swift
//  CoVi
//
//  Created by Jorge Guilabert Ibáñez on 30/06/2020.
//  Copyright © 2020 Babel SI. All rights reserved.
//

import UIKit

/**
 CoVi base scroll view.
 */
open class CoViScrollView: UIScrollView, UIScrollViewDelegate {
    
    // MARK: - Properties

    private weak var customScrollViewDelegate: CoViScrollViewDelegate?

    // MARK: - Functions
    
    public func setupDelegate(_ delegate: CoViScrollViewDelegate) {
        self.delegate = self
        self.customScrollViewDelegate = delegate
    }

    // MARK: - UIScrollViewDelegate

    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        customScrollViewDelegate?.scrollViewDidScroll?(scrollView.tag)
    }

    open func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        customScrollViewDelegate?.scrollViewDidChangeAdjustedContentInset?(scrollView.tag)
    }

    open func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        customScrollViewDelegate?.scrollViewDidEndScrollingAnimation?(scrollView.tag)
    }

    open func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        customScrollViewDelegate?.scrollViewWillBeginDecelerating?(scrollView.tag)
    }

    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        customScrollViewDelegate?.scrollViewDidEndDecelerating?(scrollView.tag)
    }
    
    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        customScrollViewDelegate?.scrollViewWillBeginDragging?(scrollView.tag)
    }

}
