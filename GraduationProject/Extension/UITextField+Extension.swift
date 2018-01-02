//
//  UITextField+Extension.swift
//  LibraryTest
//
//  Created by 윤민섭 on 2017. 2. 22..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

private var targetView: UIView!
private var emojiFlag: Int = 0

extension UITextField: UITextFieldDelegate{
    
    
    public func setTextField(fontName: String = ".SFUIText", fontSize: CGFloat, placeholderText: String = "NO_PLACEHOLDER"){
        
        if placeholderText != "NO_PLACEHOLDER"{
            self.placeholder = placeholderText
        }
        self.font = UIFont(name: fontName, size: fontSize*widthRatio)
        self.autocorrectionType = UITextAutocorrectionType.no
        self.keyboardType = UIKeyboardType.default
        self.returnKeyType = UIReturnKeyType.done
        self.delegate = self
        
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    public func setKeyboardNotification(target: UIView!){
        
        targetView = target
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    public func setEmojiFlag(){
        emojiFlag = 0
    }
    
    public func keyboardWillShow(notification:NSNotification,target: UIView) {
        adjustingHeight(show: false, notification: notification)
    }
    
    public func keyboardWillHide(notification:NSNotification) {
        targetView.y = 0
    }
    
    public func adjustingHeight(show:Bool, notification:NSNotification) {
        var userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        let changeInHeight = (keyboardFrame.height) * (show ? 1 : -1)
        let changeInEmoji : CGFloat = (42 * heightRatio) * (show ? 1 : -1)
        
        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
            
            if self.textInputMode?.primaryLanguage == nil{
                
                targetView.frame.origin.y += changeInEmoji
                emojiFlag = 1
                
            } else if self.textInputMode?.primaryLanguage == "ko-KR" && emojiFlag == 0 {
                targetView.frame.origin.y += changeInHeight
                
            } else if self.textInputMode?.primaryLanguage == "ko-KR" && emojiFlag == 1 {
                targetView.frame.origin.y += (42 * heightRatio)
                emojiFlag = 0
                
            } else{
                targetView.frame.origin.y += changeInHeight
                emojiFlag = 0
                
            }
        })
    }
    
    public func removeObserver(){
        NotificationCenter.default.removeObserver(self)
    }

    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}



