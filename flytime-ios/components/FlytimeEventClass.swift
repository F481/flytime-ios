//
//  File.swift
//  flytime-ios
//
//  Created by FRICK ; KOENIG on 23.11.17.
//

import Foundation
import MapKit

class FlytimeEvent: NSObject, MKAnnotation {
    var name: String?
    var coordinate: CLLocationCoordinate2D
    var title: String?
   // var description: String
    init(name: String?, coordinate: CLLocationCoordinate2D) {
        self.title =  String("Weingarten")
        self.name = name
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String?{
        return name
    }
    
    
}
