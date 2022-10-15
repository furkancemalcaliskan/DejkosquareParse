//
//  DetailsViewController.swift
//  DejkosquareParse
//
//  Created by Furkan Cemal Çalışkan on 18.09.2022.
//

import UIKit
import MapKit
import Parse

class DetailsViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var placeNameText: UILabel!
    
    @IBOutlet weak var placeTypeText: UILabel!
    
    @IBOutlet weak var placeAtmosphereText: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var chosenPlaceId = ""
    
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDataFromParse()
        mapView.delegate = self
        
    }
    func getDataFromParse() {
        
        let query = PFQuery(className: "Places")
        query.whereKey("objectId", equalTo: chosenPlaceId)
        query.findObjectsInBackground { objects, error in
            if error != nil {
                
                
                
            } else {
                
                if objects != nil {
                    if objects!.count > 0 {
                        
                        let chosenPlaceObject = objects![0]
                        
                        if let placeName = chosenPlaceObject.object(forKey: "name") as? String {
                            
                            self.placeNameText.text = placeName
                            
                        }
                        if let placeType = chosenPlaceObject.object(forKey: "type") as? String {
                            
                            self.placeTypeText.text = placeType
                            
                        }
                        if let placeAtmosphere = chosenPlaceObject.object(forKey: "atmosphere") as? String {
                            
                            self.placeAtmosphereText.text = placeAtmosphere
                            
                        }
                        if let placeLatitude = chosenPlaceObject.object(forKey: "latitude") as? String {
                            
                            if let placeLatitudeDouble = Double(placeLatitude) {
                                
                                self.chosenLatitude = placeLatitudeDouble
                                
                            }
                            
                        }
                        if let placeLongitude = chosenPlaceObject.object(forKey: "longitude") as? String {
                            
                            if let placeLongitudeDouble = Double(placeLongitude) {
                                
                                self.chosenLongitude = placeLongitudeDouble
                                
                            }
                            
                            
                        }
                        if let imageData = chosenPlaceObject.object(forKey: "image") as? PFFileObject {
                            
                            imageData.getDataInBackground { data, error in
                                if error == nil {
                                    
                                    if data != nil {
                                        
                                        self.imageView.image = UIImage(data: data!)
                                        
                                    }
                                    
                                }
                            }
                            
                        }
                        
                        //Maps
                        
                        let location = CLLocationCoordinate2D(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
                        
                        let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
                        
                        let region = MKCoordinateRegion(center: location, span: span)
                        
                        self.mapView.setRegion(region, animated: true)
                        
                        let annotation = MKPointAnnotation()
                        
                        annotation.coordinate = location
                        annotation.title = self.placeNameText.text
                        annotation.subtitle = self.placeTypeText.text
                        self.mapView.addAnnotation(annotation)
                        
                    }
                }
            }
            
        }
        
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            
            return nil
            
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinView == nil {
            
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
            
        } else {
            
            pinView?.annotation = annotation
        
        }
        return pinView
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.chosenLongitude != 0.0 && self.chosenLongitude != 0.0 {
            
            let requestLocation = CLLocation(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
            
            CLGeocoder().reverseGeocodeLocation(requestLocation) { placemark, error in
                if let placemark = placemark {
                    
                    if placemark.count > 0 {
                        
                        let mkPlaceMark = MKPlacemark(placemark: placemark[0])
                        let mapItem = MKMapItem(placemark: mkPlaceMark)
                        mapItem.name = self.placeNameText.text
                        
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                        
                        mapItem.openInMaps(launchOptions: launchOptions)
                        
                    }
                    
                }
            }
            
        }
    }
}
