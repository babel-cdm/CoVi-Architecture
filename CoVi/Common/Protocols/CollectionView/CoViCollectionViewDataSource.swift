//
//  CoViCollectionViewDataSource.swift
//  CoVi
//
//  Created by Alvaro Garcia on 11/05/2020.
//  Copyright © 2020 Babel. All rights reserved.
//

/**
 CoVi base collection view data source.
 */
@objc public protocol CoViCollectionViewDataSource: AnyObject {
    func numberOfItemsInSection(_ collectionViewTag: Int, _ section: Int) -> Int
    @objc optional func numberOfSections(_ collectionViewTag: Int) -> Int
}
