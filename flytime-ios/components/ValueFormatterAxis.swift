//
//  File.swift
//  flytime-ios
//
//  Created by FRICK ; KOENIG on 23.11.17.
//
// Sets the Time Labes for the X-axis
// EEEEEE = Mon, Thu...
// HH = 12, 13...
import Foundation
import Charts

public class DateValueFormatterDay: NSObject, IAxisValueFormatter {
    private let dateFormatter = DateFormatter()
    
    override init() {
        super.init()
        dateFormatter.dateFormat = "EEEEEE"
        
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}
public class DateValueFormatterHour: NSObject, IAxisValueFormatter {
    private let dateFormatter = DateFormatter()
    
    override init() {
        super.init()
        dateFormatter.dateFormat = "HH"
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}

