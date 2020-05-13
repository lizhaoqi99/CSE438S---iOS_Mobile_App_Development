//
//  MapScreen.swift
//  HousingSensei
//
//  Created by Andy Wang on 11/19/19.
//  Copyright © 2019 InvictusProgramming. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ResultsAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var id: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, id: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.id = id
        //super.init()
    }
}


class MapScreen: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var latlongLabel: UILabel!
    @IBOutlet weak var stateName: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var loadingMark: UIActivityIndicatorView!
    @IBAction func resetRegion(_ sender: UIButton) {
        centerViewOnUserLocation()
    }
    @IBAction func toCollection(_ sender: UIButton) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let infoVC = storyBoard.instantiateViewController(withIdentifier: "collectionPage") as! CollectionView
        if(rentData.isEmpty == false){
            infoVC.collectionData = rentData[0].listings
        }
        
        self.present(infoVC, animated:true, completion:nil)
    }
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 3000
    let searchRadius: Int = 5
    let resultNum = 200
    var previousLocation: CLLocation?
    var rentData: [RentResults] = []
    var imageCache : [String] = []
    var disPlay: [String] = []
    var state: String = "CA"
    var city: String = "San Francisco"
    var count = 0
    var fetchError = false
    let notFound: UIImage = UIImage(named: "image-not-found-1")!
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: "Annotation")
        loadingMark.isHidden = true
        mapView.delegate = self
        checkLocationServices()
        displayLocation()
        //fetchData()
        //        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "theCell")
        //        self.tableView.delegate = self
        //        self.tableView.dataSource = self
        //        self.tableView.reloadData()
        
        
        
    }
    @IBAction func reloadData(_ sender: Any) {
        fetchData()
    }
    
    func fetchData(){
        let headers = [
            "x-rapidapi-host": "realtor.p.rapidapi.com",
            "x-rapidapi-key": "8a92aee306msh2c1a1dc66065230p1f1730jsn4218d0053898"
        ]
        
        let url  = "https://realtor.p.rapidapi.com/properties/list-for-rent?radius=\(self.searchRadius)&sort=relevance&state_code=\(self.state)&limit=\(self.resultNum)&city=\(self.city)&offset=0"
        
        let realURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        loadingMark.isHidden = false
        loadingMark.startAnimating()
        DispatchQueue.global().async {
            let request = NSMutableURLRequest(url: NSURL(string: realURL!)! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error as Any)
                    self.fetchError = true
                } else {
                    self.fetchError = false
                    self.rentData = [try! JSONDecoder().decode(RentResults.self, from: data!)]
                }
            })
            dataTask.resume()
        }
        
        if(fetchError == true){
            print("Error: failed to fetch data!")
        }
        else{
            if(rentData.isEmpty == false){
                DispatchQueue.main.async {
                    self.loadingMark.isHidden = true
                    self.loadingMark.stopAnimating()
                    let previousAnnotations = self.mapView.annotations
                    self.mapView.removeAnnotations(previousAnnotations)
                    print("----------Annotations Removed------------")
                    
                    for item in self.rentData[0].listings{
                        let thisCoord = CLLocationCoordinate2D(latitude: item.lat!, longitude: item.lon!)
                        var thisAnnotation = ResultsAnnotation(coordinate: thisCoord, title: item.price, subtitle: item.address, id: item.property_id)
                        var isExist = false
                        for annotation in self.mapView.annotations{
                            if annotation.coordinate.longitude == thisAnnotation.coordinate.longitude && annotation.coordinate.latitude == thisAnnotation.coordinate.latitude{
                                isExist = true
                                thisAnnotation = annotation as! ResultsAnnotation
                            }
                        }
                        if(!isExist){
                            self.mapView.addAnnotation(thisAnnotation)
                        }
                        
                    }
                    print("+++++++++++Annotations Added++++++++++++")
                }
            }
            
        }
        
        
    }
    
    func displayImage() {
        for i in 0..<rentData[0].listings.count{
            imageCache.append(self.rentData[0].listings[i].address!)
        }
    }
    
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            startTrackingUserLocation()
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }
    
    
    func startTrackingUserLocation() {
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: mapView)
    }
    
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}


extension MapScreen: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}


extension MapScreen: MKMapViewDelegate {
    func mapView( _ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let center = getCenterLocation(for: mapView)
        
        guard let previousLocation = self.previousLocation else { return }
        
        guard center.distance(from: previousLocation) > 50 else {
            return
        }
        count += 1
        print("{Region Changed for \(count) times}")
        //self.mapView.removeAnnotations(self.mapView.annotations
        
        
        displayLocation()
        //fetchData()
        
    }
    
    // Display current annotaions
    //    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    //        if let resultAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as? MKMarkerAnnotationView{
    //            resultAnnotationView.animatesWhenAdded = true
    //            resultAnnotationView.titleVisibility = .adaptive
    //            resultAnnotationView.titleVisibility = .adaptive
    //
    //            return resultAnnotationView
    //        }
    //
    //        return nil
    //    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.image = UIImage(named: "pin-1")
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        let resultAnno = annotation as! ResultsAnnotation
        annotationView!.detailCalloutAccessoryView = UIImageView(image: notFound)
        
        // Left Accessory
        let leftAccessory = UILabel(frame: CGRect(x: 0,y: 0,width: 50,height: 30))
        leftAccessory.text = resultAnno.id
        //leftAccessory.font = UIFont(name: "Verdana", size: 10)
        annotationView?.leftCalloutAccessoryView = leftAccessory
        
        // Right accessory view
        let image = notFound
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.setImage(image, for: UIControl.State())
        annotationView?.rightCalloutAccessoryView = button
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        //self.performSegue(withIdentifier: "detailedVC", sender: nil)
        print("click")
        
        //      self.performSegue(withIdentifier: "detailedVC", sender: self)
        let selectedAnnotation: MKAnnotation?
        let detailedVC: DetailedVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailedVC") as! DetailedVC
        selectedAnnotation = view.annotation
        guard selectedAnnotation?.subtitle != nil else{return}
        detailedVC.address = (selectedAnnotation?.subtitle)!
        //self.present(detailedVC, animated: true, completion: nil)
    }
    
    func displayLocation(){
        let center = getCenterLocation(for: mapView)
        self.previousLocation = center
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let _ = error {
                //TODO: Show alert informing the user
                return
            }
            
            guard let placemark = placemarks?.first else {
                //TODO: Show alert informing the user
                return
            }
            
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
            let longitude = placemark.location?.coordinate.longitude ?? 0.0
            let latitude = placemark.location?.coordinate.latitude ?? 0.0
            let roundLong = round(100000*longitude)/100000
            let roundLat = round(100000*latitude)/100000
            //guard placemark.administrativeArea == nil else {
            self.state = placemark.administrativeArea!
            print(self.state)
            //return
            
            //}
            //guard placemark.subAdministrativeArea == nil else{
            self.city = placemark.subAdministrativeArea!
            print(self.city)
            //return
            //}
            
            //self.latlongLabel.text = "\(roundLat) || \(roundLong)"
            //self.addressLabel.text = "\(streetNumber) \(streetName)"
            //self.stateName.text = self.state
            //self.cityName.text = self.city
            
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*if(rentData.count == 0){
         print("苏迪佛")
         return 0
         }
         else{
         print("就撕豆腐干")
         return rentData[0].listings.count
         }*/
        return imageCache.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "theCell")! as UITableViewCell
        tableCell.textLabel!.text = rentData[0].listings[indexPath.row].address
        
        return tableCell
        
    }
}


