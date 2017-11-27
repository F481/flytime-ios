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

public class DateValueFormatter: NSObject, IAxisValueFormatter {
    private let dateFormatter = DateFormatter()
    
    override init() {
        super.init()
        dateFormatter.dateFormat = "HH:mm"
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}

public class IntAxisValueFormatter: NSObject, IAxisValueFormatter {
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return "\(Int(value))"
    }
}
