//
//  mapViewController.swift
//  task
//
//  Created by mino on 5/9/18.
//  Copyright © 2018 marwa. All rights reserved.
//

import UIKit
import MapKit

protocol MapDelegate {
    func messageData(data coor: String,lat:String,lng:String)
}


class mapViewController: UIViewController ,MKMapViewDelegate {
 
    @IBOutlet weak var mapVie: MKMapView!
    var delegate : MapDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        mapVie.addGestureRecognizer(gestureRecognizer)
        }
    func handleTap(_ gestureReconizer: UILongPressGestureRecognizer) {
        let location = gestureReconizer.location(in: mapVie)
        let coordinate = mapVie.convert(location,toCoordinateFrom: mapVie)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapVie.addAnnotation(annotation)
        let coor=String(coordinate.latitude)+","+String(coordinate.longitude)
        self.delegate?.messageData(data:coor,lat: String(coordinate.latitude),lng:String( coordinate.longitude));
        self.navigationController?.popViewController(animated:true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
