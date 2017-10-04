//
//  GraphViewDataSourceProtocol.swift
//  GraphIt
//
//  Created by Ömer Yetik on 04/10/2017.
//  Copyright © 2017 Ömer Yetik. All rights reserved.
//

import Foundation

protocol GraphViewDataSource {
    
    func yValue(for xValue: Double) -> Double
    
}
