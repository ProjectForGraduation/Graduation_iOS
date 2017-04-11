//
//  UIButton+Extension.swift
//  LibraryTest
//
//  Created by 윤민섭 on 2017. 2. 22..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

extension UIButton{
    
    public func setButton(imageName: String, target: NSObject, action: Selector){
        self.setImage(UIImage(named: imageName), for: .normal)
        self.addTarget(target, action: action, for: .touchUpInside)
    }
    
    
    /*
    버튼을 한줄로
    사용법 : button.setButton(title: "OH", target: self, action: #selector(printAction), size: 20, color: UIColor.mainColor)
    */
    public func setButton(title: String, target: NSObject, action: Selector, fontName: String = ".SFUIText", fontSize: CGFloat, color: UIColor){
        self.setTitle(title, for: .normal)
        self.setTitleColor(color, for: .normal)
        self.titleLabel?.font = UIFont(name: fontName, size: fontSize*widthRatio)
        self.addTarget(target, action: action, for: .touchUpInside)
    }
    
    public func setButton(title: String, fontName: String = ".SFUIText", fontSize: CGFloat, color: UIColor){
        self.setTitle(title, for: .normal)
        self.setTitleColor(color, for: .normal)
        self.titleLabel?.font = UIFont(name: fontName, size: fontSize*widthRatio)
    }
    
}



