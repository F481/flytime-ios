//
//  File.swift
//  flytime-ios
//
//  Created by KOENIG on 24.11.17.
//  Copyright © 2017 KOENIG. All rights reserved.
//

import Foundation
import Charts

class XAxisValueFormatter: IAxisValueFormatter {
    var mValues: [String]
    
    init(values: [String]){
        mValues = values
    }

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return mValues[Int(value)]
    }
    
    
}

