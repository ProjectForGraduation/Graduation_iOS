//
//  Alert+Extension.swift
//  GraduationProject
//
//  Created by 윤민섭 on 2017. 5. 22..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import Foundation
import UIKit


func alertWindow(alertView: UIAlertController){
    let alertWindow = UIWindow(frame: UIScreen.main.bounds)
    alertWindow.rootViewController = UIViewController()
    alertWindow.windowLevel = UIWindowLevelAlert + 1
    alertWindow.makeKeyAndVisible()
    alertWindow.rootViewController?.present(alertView, animated: true, completion: nil)
}
