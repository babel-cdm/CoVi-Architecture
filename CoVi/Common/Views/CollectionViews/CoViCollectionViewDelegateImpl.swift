//
//  CoViCollectionViewDelegateImpl.swift
//  CoVi
//
//  Created by Jorge Guilabert Ibáñez on 14/05/2020.
//  Copyright © 2020 Babel SI. All rights reserved.
//

import UIKit

open class CoViCollectionViewDelegateImpl: NSObject, UICollectionViewDelegate {

    // MARK: - Properties
    
    private weak var collectionViewDelegate: CoViCollectionViewDelegate?

    // MARK: - Initializer

    public init(_ delegate: CoViCollectionViewDelegate?) {
        self.collectionViewDelegate = delegate
        super.init()
    }

    // MARK: - UICollectionViewDelegate

    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let didSelectItemAt = collectionViewDelegate?.didSelectItemAt {
            didSelectItemAt(collectionView.tag, indexPath)
        }
    }

    open func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let didDeselectRowAt = collectionViewDelegate?.didDeselectRowAt {
            didDeselectRowAt(collectionView.tag, indexPath)
        }
    }

    open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let willDisplay = collectionViewDelegate?.willDisplay {
            willDisplay(collectionView.tag, indexPath)
        }
    }

    open func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        if let shouldHighlightRowAt = collectionViewDelegate?.shouldHighlightRowAt {
            return shouldHighlightRowAt(collectionView.tag, indexPath)
        }
        return true
    }

    open func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let didHighlightRowAt = collectionViewDelegate?.didHighlightRowAt {
            didHighlightRowAt(collectionView.tag, indexPath)
        }

        /// Set highlight color
        if let coviCell = collectionView.cellForItem(at: indexPath) as? CoViCollectionViewCell,
            let highlightColor = coviCell.highlightColor {
            let selectedBackgroundView = UIView()
            selectedBackgroundView.backgroundColor = highlightColor

            if coviCell.selectedBackgroundView != nil {
                coviCell.selectedBackgroundView?.addSubview(childView: selectedBackgroundView,
                                                        constraintType: .container)
            } else {
                coviCell.insertSubview(childView: selectedBackgroundView,
                                   at: 0,
                                   constraintType: .container)
            }
        }
    }

    open func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let didUnhighlightRowAt = collectionViewDelegate?.didUnhighlightRowAt {
            didUnhighlightRowAt(collectionView.tag, indexPath)
        }

        /// Remove highlight color
        if let coviCell = collectionView.cellForItem(at: indexPath) as? CoViCollectionViewCell,
            let _ = coviCell.highlightColor {
            if coviCell.selectedBackgroundView != nil {
                coviCell.selectedBackgroundView = nil
            } else {
                coviCell.subviews.first?.removeFromSuperview()
            }
        }
    }

    // MARK: - UIScrollViewDelegate

    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let scrollViewDidScroll = collectionViewDelegate?.scrollViewDidScroll {
            scrollViewDidScroll(scrollView.tag)
        }
    }

    open func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        if let scrollViewDidChangeAdjustedContentInset = collectionViewDelegate?.scrollViewDidChangeAdjustedContentInset {
            scrollViewDidChangeAdjustedContentInset(scrollView.tag)
        }
    }

    open func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if let scrollViewDidEndScrollingAnimation = collectionViewDelegate?.scrollViewDidEndScrollingAnimation {
            scrollViewDidEndScrollingAnimation(scrollView.tag)
        }
    }

    open func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if let scrollViewWillBeginDecelerating = collectionViewDelegate?.scrollViewWillBeginDecelerating {
            scrollViewWillBeginDecelerating(scrollView.tag)
        }
    }

    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let scrollViewDidEndDecelerating = collectionViewDelegate?.scrollViewDidEndDecelerating {
            scrollViewDidEndDecelerating(scrollView.tag)
        }
    }

    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let scrollViewWillBeginDragging = collectionViewDelegate?.scrollViewWillBeginDragging {
            scrollViewWillBeginDragging(scrollView.tag)
        }
    }
    
}
