//
//  CoViDisposeBag.swift
//  CoVi
//
//  Created by Jorge Guilabert Ibáñez on 30/09/2019.
//  Copyright © 2019 Babel SI. All rights reserved.
//

import Foundation

public protocol CoViDisposable {
    func disposed(by bag: CoViDisposeBag)
    func dispose()
}

public class CoViDisposeBag {}

let disposeBagNotificationId = NSNotification.Name(rawValue: "disposeBagNotificationId")
let disposeBagNotificationParameter = "disposeBagNotificationParameter"
