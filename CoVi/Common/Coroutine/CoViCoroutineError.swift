//
//  CoViCoroutineError.swift
//  CoVi
//
//  Created by Jorge Guilabert Ibáñez on 14/05/2020.
//  Copyright © 2020 Babel SI. All rights reserved.
//

public enum CoViCoroutineError: Error {
    case mainThread
    case timedOut
    case unknown(_ description: String)
}
