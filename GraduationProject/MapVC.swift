//
//  MapVC.swift
//  GraduationProject
//
//  Created by 윤민섭 on 2017. 3. 19..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit
import GoogleMaps

class MapVC: UIViewController {

    static var latitude : Double = 0.0
    static var longitude : Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let camera = GMSCameraPosition.camera(withLatitude: MapVC.latitude,
                                                          longitude: MapVC.longitude, zoom: 16)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        self.view = mapView
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(MapVC.latitude, MapVC.longitude)
        marker.map = mapView
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
