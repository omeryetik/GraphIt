//
//  GenericGrapDataSource.swift
//  GraphIt
//
//  Created by Ömer Yetik on 15/10/2017.
//  Copyright © 2017 Ömer Yetik. All rights reserved.
//

import Foundation

struct GenericGraphDataSource: GraphViewDataSource {
    
    func yValue(for xValue: Double) -> Double {
        return cos(xValue)
    }
    
}
