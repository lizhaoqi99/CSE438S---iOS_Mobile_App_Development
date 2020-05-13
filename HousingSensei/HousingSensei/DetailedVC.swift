//
//  DetailedVC.swift
//  HousingSensei
//
//  Created by MonAster on 2019/12/1.
//  Copyright © 2019 InvictusProgramming. All rights reserved.
//

import UIKit
import MapKit

class DetailedVC: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var houseImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var image: UIImage?
    var address: String?
    var price: String?
    var lat: Double?
    var lon: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        houseImage.image = image
        let scrollView = UIScrollView(frame: UIScreen.main.bounds)
        view.addSubview(scrollView)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 105, width: view.frame.maxX,height: view.frame.midY - 50))
        // TODO: import image
        //imageView.image = image
        //scrollView.addSubview(imageView)
        

        addressLabel.text = address
        
        
        
        priceLabel.text = price
        
        let thisPlace = MKPointAnnotation()
        thisPlace.title = price
        thisPlace.subtitle = address
        thisPlace.coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
        mapView.addAnnotation(thisPlace)
        let region = MKCoordinateRegion.init(center: CLLocationCoordinate2D(latitude: lat!, longitude: lon!), latitudinalMeters: 2000, longitudinalMeters: 2000)
        mapView.setRegion(region, animated: true)
        //background.image = UIImage(named: "back.jpeg")
    }
        // Do any additional setup after loading the view.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else {return nil}
        let identifier = "Annot"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil{
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        }
        else{
            annotationView!.annotation = annotation
        }
        return annotationView
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
