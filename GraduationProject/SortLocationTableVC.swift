//
//  SortLocationTableVC.swift
//  GraduationProject
//
//  Created by 윤민섭 on 2017. 3. 18..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class SortLocationTableVC: UIViewController {
    
    var locationManager = LocationManager()
    var locValue: Dictionary<String,Double> = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        findLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func findLocation(){
        let userId: String! = ""
        locValue = locationManager.getUserLocation()
        print(locValue)
        locationManager.setLocationDB(userId)
    }
    
    // MARK: - Table view data source

}
