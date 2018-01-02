//
//  UIColor+Extension.swift
//  LibraryTest
//
//  Created by 윤민섭 on 2017. 2. 22..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

extension UIColor {
    
    public static var mainColor: UIColor {
        get{
            return UIColor(r: 68, g: 67, b: 68, alpha: 1)
        }set(value) {
            self.mainColor = value
        }
    }
    
    convenience init(r: CGFloat,g: CGFloat,b: CGFloat,alpha: CGFloat){
        self.init(red: r/255, green: g/255, blue: b/255, alpha: alpha)
    }
    
}
