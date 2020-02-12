//
//  CoViTableViewDataSource.swift
//  ViperArchitecture
//
//  Created by Jorge Guilabert Ibáñez on 06/02/2020.
//  Copyright © 2020 Babel. All rights reserved.
//

import UIKit

@objc public protocol CoViTableViewDataSource: class {
    func numberOfRowsInSection(_ tableViewTag: Int, _ section: Int) -> Int
    @objc optional func canEditRowAt(_ tableViewTag: Int, _ indexPath: IndexPath) -> Bool
    @objc optional func canMoveRowAt(_ tableViewTag: Int, _ indexPath: IndexPath) -> Bool
    @objc optional func commit(_ tableViewTag: Int, editingStyle: CoViTableView.CellEditingStyle, forRowAt indexPath: IndexPath)
    @objc optional func moveRowAt(_ tableViewTag: Int, sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    @objc optional func titleForHeaderInSection(_ tableViewTag: Int, _ section: Int) -> String?
    @objc optional func titleForFooterInSection(_ tableViewTag: Int, _ section: Int) -> String?
    @objc optional func sectionForSectionIndexTitle(_ tableViewTag: Int, title: String, at index: Int) -> Int
}
