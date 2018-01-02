//
//  RegisterUserVC.swift
//  GraduationProject
//
//  Created by 윤민섭 on 2017. 4. 25..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class RegisterUserVC: UIViewController ,UITextFieldDelegate{

    var apiManager = ApiManager()

    @IBOutlet var inputName: UITextField!
    @IBOutlet var inputId : UITextField!
    @IBOutlet var inputPw : UITextField!
    @IBOutlet var reInputPw : UITextField!
    @IBOutlet var registerBtn : UIButton!
    
    override var isEditing: Bool{
        willSet(newValue){
            if !newValue {
                let myViews = view.subviews.filter{$0 is UITextField}
                for view in myViews{
                    let tf = view as! UITextField
                    tf.endEditing(true)
                }
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isEditing = false
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }

    @IBAction func registerBtnAction(){
        apiManager.setApi(path: "/users/regist", method: .post, parameters: ["login_id":inputId.text!,"login_pw":inputPw.text!,"reEnterpw":reInputPw.text!,"user_name":inputName.text!,"public_range":1], header: [:])
        apiManager.requestRegisterUser { (code) in
            if code == 0 {
                self.basicAlert(title: "반갑습니다", message: "회원가입을 축하드립니다!",true)
            }else{
                self.basicAlert(title: "죄송합니다", message: "정보를 다시 확인해주세요!", false)
            }
        }
    }
    
    func basicAlert(title : String,message : String, _ agree: Bool){
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "네", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            alertView.dismiss(animated: true, completion: nil)
            if agree{
                self.dismiss(animated: false, completion: nil)
            }
        })
        
        alertView.addAction(action)
        
        alertWindow(alertView: alertView)
    }
    
    func alertWindow(alertView: UIAlertController){
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindowLevelAlert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alertView, animated: true, completion: nil)
    }


}
