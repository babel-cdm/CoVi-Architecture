//
//  CoViTableViewDelegate.swift
//  ViperArchitecture
//
//  Created by Jorge Guilabert Ibáñez on 06/02/2020.
//  Copyright © 2020 Babel. All rights reserved.
//

import UIKit

/**
 CoVi base table view delegate.
 */
@objc public protocol CoViTableViewDelegate: class {
    @objc optional func heightForRowAt(_ tableViewTag: Int, _ indexPath: IndexPath) -> CGFloat
    @objc optional func estimatedHeightForRowAt(_ tableViewTag: Int, _ indexPath: IndexPath) -> CGFloat
    @objc optional func didSelectRowAt(_ tableViewTag: Int, _ indexPath: IndexPath)
    @objc optional func didDeselectRowAt(_ tableViewTag: Int, _ indexPath: IndexPath)
    @objc optional func willDisplay(_ tableViewTag: Int, _ indexPath: IndexPath)
    @objc optional func shouldHighlightRowAt(_ tableViewTag: Int, _ indexPath: IndexPath) -> Bool
    @objc optional func didHighlightRowAt(_ tableViewTag: Int, _ indexPath: IndexPath)
    @objc optional func didUnhighlightRowAt(_ tableViewTag: Int, _ indexPath: IndexPath)
}
