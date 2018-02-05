//
//  MapController.swift
//  flytime-ios
//
//  Created by FRICK ; KOENIG on 23.11.17.
//
// Map View
// handels Eventes on Map
import UIKit
import MapKit
import CoreLocation

class MapController: UIViewController {
    let regionRadius: CLLocationDistance = 100000
    let initialLocation = CLLocation(latitude: 47.7814, longitude: 9.6118)
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        initAnnotation()
        centerMapOnLocation(location: initialLocation)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)}
    
    func initAnnotation (){
        let event = FlytimeEvent(name: "DroneRacing", coordinate: CLLocationCoordinate2D(latitude: 47.7814, longitude: 9.6118))
        mapView.addAnnotation(event)
    }



}
extension MapController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        guard let annotation = annotation as? FlytimeEvent else { return nil }

        let identifier = "marker"
        var view: MKMarkerAnnotationView

        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {

            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
           // view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            view.glyphText = "Regen"
            view.markerTintColor = UIColor.blue

        }
        return view
    }
}
