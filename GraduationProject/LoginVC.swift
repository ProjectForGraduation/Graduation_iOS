//
//  LoginVC.swift
//  GraduationProject
//
//  Created by 윤민섭 on 2017. 4. 25..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class LoginVC: UIViewController , UITextFieldDelegate{

    var idImage : UIImageView!
    var pwImage : UIImageView!
    @IBOutlet var inputId : UITextField!
    @IBOutlet var inputPw : UITextField!
    @IBOutlet var loginBtn : UIButton!

    let apiManager = ApiManager()
    let users = UserDefaults.standard
    
    @IBAction func loginBtnAction(){
        apiManager.setApi(path: "/users/login", method: .post, parameters: ["login_id":inputId.text!,"login_pw":inputPw.text!], header: [:])
        apiManager.requestLogin { (meta, token) in
            if meta == 0 {
                self.users.set(token, forKey: "token")
                self.users.set(self.inputId.text!, forKey: "userid")
                self.performSegue(withIdentifier: "mainSegue", sender: self)
            }else{
                basicAlert(title: "오류!", message: "아이디, 비밀번호를 확인해주세요.", false)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        inputPw.endEditing(true)
        inputId.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
}
