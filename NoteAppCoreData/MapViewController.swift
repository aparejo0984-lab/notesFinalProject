import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var latitude: Double = 0.0
    var longtitute: Double = 0.0
    
    @IBOutlet weak var latitudeTxt: UILabel!
    @IBOutlet weak var longtitudeTxt: UILabel!
    @IBOutlet weak var locationDetails: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        latitudeTxt.text = String(latitude)
        longtitudeTxt.text = String(longtitute)
        
        let initialLocation = CLLocation(latitude: latitude, longitude: longtitute)
        mapView.centerToLocation(initialLocation)
        
        CLGeocoder().reverseGeocodeLocation(initialLocation) { placemarks, error in

            guard let placemark = placemarks?.first else {
                let errorString = error?.localizedDescription ?? "Unexpected Error"
                print("Unable to reverse geocode the given location. Error: \(errorString)")
                return
            }
            let reversedGeoLocation = ReversedGeoLocation(with: placemark)
            self.locationDetails.text = reversedGeoLocation.formattedCityCountry
            print(reversedGeoLocation.formattedCityCountry)
        }
        
        // zoom out
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200000)
        mapView.setCameraZoomRange(zoomRange, animated: true)
    }
}

private extension MKMapView{
    func centerToLocation(_ location: CLLocation,regionRadius: CLLocationDistance = 1000) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
    
}
