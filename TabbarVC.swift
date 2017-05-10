//
//  TabBarVC.swift
//  tab_bar
//
//  Created by 윤민섭 on 2017. 3. 7..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit
import SwipeableTabBarController

class TabBarVC: UITabBarController {
    
    var imageMain : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "tvNEnjoystoriesM", size: 27)!]
        //tvNEnjoystoriesL
        UITabBar.appearance().barTintColor = UIColor.white

        
    }
    
    @IBAction func writeBtnClicked(_ sender: UIButton) {
        
//        performSegue(withIdentifier: "writeSegue", sender: self)
    
//        // Show Fusuma
//        let fusuma = FusumaViewController()
//        
//        fusuma.delegate = self
//        fusuma.cropHeightRatio = 1.0
//        fusumaCropImage = false
//        fusumaTintColor = UIColor.darkGray
//        fusumaBackgroundColor = UIColor.darkGray
//        //
//        self.present(fusuma, animated: false, completion: nil)
    }
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        if segue.identifier == "writeSegue"
//        {
//
//            let destination = segue.destination as! UINavigationController
//            let realdest = destination.topViewController as! WriteVC
//            realdest.receivedImg = imageMain
//            
//        }
//        else if segue.identifier == "mainToDetail"
//        {
//            let destination = segue.destination as! DetailMissionViewController
//            destination.receivedImg = MainController.subOriImage
//            destination.receivedLbl = MainController.subLabel
//        }
    }


