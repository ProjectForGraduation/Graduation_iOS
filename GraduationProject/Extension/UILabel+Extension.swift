//
//  UILabel+Extension.swift
//  LibraryTest
//
//  Created by 윤민섭 on 2017. 2. 22..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

extension UILabel{

    /*
    라벨 지정
    사용법 :  label.setLabel(text: "hi", align: .center, size: 40, target: self.view)
    */
    
    public func setLabel(text: String, align: NSTextAlignment, fontName: String = ".SFUIText", fontSize: CGFloat, color: UIColor){
        self.text = text
        self.textAlignment = align
        self.font = UIFont(name: fontName, size: fontSize*widthRatio)
        self.textColor = color
    }
    
    // 행간
    
    func setLineHeight(lineHeight: CGFloat) {
        let text = self.text
        if let text = text {
            let attributeString = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            
            style.lineSpacing = lineHeight
            attributeString.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, text.characters.count))
            self.attributedText = attributeString
        }
    }
    
    // 자간
    
    func addTextSpacing(spacing: CGFloat){
        let attributedString = NSMutableAttributedString(string: self.text!)
        attributedString.addAttribute(NSKernAttributeName, value: spacing, range: NSRange(location: 0, length: self.text!.characters.count))
        self.attributedText = attributedString
    }

}
