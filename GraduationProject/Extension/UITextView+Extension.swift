//
//  UITextField+Extension.swift
//  LibraryTest
//
//  Created by 윤민섭 on 2017. 2. 22..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

private var targetView: UIView!
private var targetTable: UITableView!
private var emojiFlag: Int = 0

extension UITextView: UITextViewDelegate{
    
    
    public func setTextView(fontName: String = ".SFUIText", size: CGFloat){
        
        self.font = UIFont(name: fontName, size: size*heightRatio)
        self.autocorrectionType = UITextAutocorrectionType.no
        self.keyboardType = UIKeyboardType.default
        self.returnKeyType = UIReturnKeyType.done
        self.delegate = self
        
    }
    
    public func setFontSize(fontName: String = ".SFUIText",size: CGFloat){
        self.font = UIFont(name: fontName, size: size*heightRatio)
    }
    
    
    /*
     키보드 올라갈 때 화면 올림
     사용법 : textField.setKeyboardNotification(target: self.view)
     
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
     textField.endEditing(true)
     textField.setEmojiFlag()
     }
     */
    
    
    public func setKeyboardNotification(target: UIView!){
        
        targetView = target
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    public func setTableView(target: UITableView){
        targetTable = target
    }
    
    public func setEmojiFlag(){
        emojiFlag = 0
    }
    
    
    public func keyboardWillShow(notification:NSNotification,target: UIView) {
        adjustingHeight(show: false, notification: notification)
    }
    
    public func keyboardWillHide(notification:NSNotification) {
        targetTable.frame.origin.y -= 216
        targetTable.frame.size.height += 216
        targetView.frame.origin.y = 0
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
                targetTable.frame.size.height += changeInHeight
                targetTable.frame.origin.y -= changeInHeight
                
            } else if self.textInputMode?.primaryLanguage == "ko-KR" && emojiFlag == 1 {
                targetView.frame.origin.y += (42 * heightRatio)
                
                emojiFlag = 0
            } else{
                targetView.frame.origin.y += changeInHeight
                targetTable.frame.size.height += changeInHeight
                targetTable.frame.origin.y -= changeInHeight
                emojiFlag = 0
            }
            self.tableViewScrollToBottom(animated: false)
        })
        
        
    }
    
    public func removeObserver(){
        NotificationCenter.default.removeObserver(self)
    }
    
    func tableViewScrollToBottom(animated: Bool) {
        let numberOfSections = targetTable.numberOfSections
        let numberOfRows = targetTable.numberOfRows(inSection: numberOfSections-1)
        
        if numberOfRows > 0 {
            let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
            targetTable.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
    }
    
    
}



