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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        UITabBar.appearance().barTintColor = UIColor.white
    }
    
}


