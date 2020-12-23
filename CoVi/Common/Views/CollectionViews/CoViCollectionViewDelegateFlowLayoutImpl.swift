//
//  CoViCollectionViewDelegateFlowLayoutImpl.swift
//  CoVi
//
//  Created by Jorge Guilabert Ibáñez on 14/05/2020.
//  Copyright © 2020 Babel SI. All rights reserved.
//

import UIKit

open class CoViCollectionViewDelegateFlowLayoutImpl: CoViCollectionViewDelegateImpl, UICollectionViewDelegateFlowLayout {

    // MARK: - Properties

    private weak var collectionViewDelegateFlowLayout: CoViCollectionViewDelegateFlowLayout?

    // MARK: - Initializer

    public init(_ delegate: CoViCollectionViewDelegateFlowLayout?) {
        self.collectionViewDelegateFlowLayout = delegate
        super.init(delegate)
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let sizeForItem = collectionViewDelegateFlowLayout?.sizeForItem {
            let size = sizeForItem(collectionView.tag, indexPath)
            return CGSize(width: CGFloat(size.width), height: CGFloat(size.height))
        }
        return CGSize(width: collectionView.frame.size.height, height: collectionView.frame.size.height)
    }

}
