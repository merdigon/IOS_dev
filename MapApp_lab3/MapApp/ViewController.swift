//
//  ViewController.swift
//  MapApp
//
//  Created by merdigon on 11/1/16.
//  Copyright © 2016 merdigonSzymon. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    var clLocationManager: CLLocationManager!
    let spanLenght = 4000.0
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var mapView: MKMapView!
        
    @IBAction func btnClear_Pressed(sender: AnyObject) {
        mapView.removeAnnotations(mapView.annotations)
        btnClear.enabled = false
    }
    
    @IBAction func btnStop_Pressed(sender: AnyObject) {
        btnStop.enabled = false
        btnStart.enabled = true
        clLocationManager.stopUpdatingLocation()
        mapView.showsUserLocation = btnStop.enabled
    }
    
    @IBAction func btnStart_Pressed(sender: AnyObject) {
        btnStart.enabled = false
        btnStop.enabled = true
        btnClear.enabled = true
        clLocationManager.startUpdatingLocation()
        mapView.showsUserLocation = btnStop.enabled
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnStop.enabled = false
        btnClear.enabled = false
        mapView.mapType = .HybridFlyover
        
        if (CLLocationManager.locationServicesEnabled())
        {
            clLocationManager = CLLocationManager()
            clLocationManager.requestWhenInUseAuthorization()
            clLocationManager.delegate = self
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let gotLocation = locations.last!.coordinate
        
        var spanDelta = 0.0
        if let speed = locations.last?.speed {
            if speed > 0 {
                spanDelta = speed/spanLenght
            }
        }
        
        let currentLocationPointAnn = MKPointAnnotation()
        currentLocationPointAnn.coordinate = gotLocation
        mapView.addAnnotation(currentLocationPointAnn)
        
        let locationArea = MKCoordinateRegion(center: gotLocation, span: MKCoordinateSpan(latitudeDelta: spanDelta, longitudeDelta: spanDelta))
        mapView.setRegion(locationArea, animated: true)
    }}

