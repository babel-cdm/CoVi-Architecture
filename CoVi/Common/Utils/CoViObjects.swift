//
//  CoViObjects.swift
//  CoVi
//
//  Created by Jorge Guilabert Ibáñez on 14/05/2020.
//  Copyright © 2020 Babel SI. All rights reserved.
//

@objc public class CVSize: NSObject {

    public var width: Float = 0
    public var height: Float = 0

    public init(width: Float, height: Float) {
        self.width = width
        self.height = height
    }
}

@objc public class CVPoint: NSObject {

    public var x: Float = 0
    public var y: Float = 0

    public init(x: Float, y: Float) {
        self.x = x
        self.y = y
    }
}
