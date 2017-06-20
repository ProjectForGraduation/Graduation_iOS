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
    
    var idImage : UIImageView!
    var nameImage : UIImageView!
    var pwImage : UIImageView!
    var rePwImage : UIImageView!
    var inputName: UITextField!
    var inputId : UITextField!
    var inputPw : UITextField!
    var reInputPw : UITextField!
    var registerBtn : UIButton!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup(){
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "tvNEnjoystoriesM", size: 27)!]
        
        idImage = UIImageView()
        idImage.rframe(x: 52, y: 150, width: 38, height: 38)
        idImage.image = UIImage(named: "loginID")
        self.view.addSubview(idImage)
        
        inputId = UITextField()
        inputId.rframe(x: 100, y: 155, width: 200, height: 30)
        inputId.setBottomBorder()
        inputId.placeholder = "아이디"
        self.view.addSubview(inputId)
        
        nameImage = UIImageView()
        nameImage.rframe(x: 52, y: 220, width: 38, height: 38)
        nameImage.image = UIImage(named: "loginID")
        self.view.addSubview(nameImage)
        
        inputName = UITextField()
        inputName.rframe(x: 100, y: 225, width: 200, height: 30)
        inputName.setBottomBorder()
        inputName.placeholder = "이름"
        self.view.addSubview(inputName)
        
        
        pwImage = UIImageView()
        pwImage.rframe(x: 50, y: 290, width: 40, height: 40)
        pwImage.image = UIImage(named: "loginPw")
        self.view.addSubview(pwImage)
        
        inputPw = UITextField()
        inputPw.rframe(x: 100, y: 295, width: 200, height: 30)
        inputPw.setBottomBorder()
        inputPw.placeholder = "비밀번호"
        inputPw.isSecureTextEntry = true
        self.view.addSubview(inputPw)
        
        rePwImage = UIImageView()
        rePwImage.rframe(x: 50, y: 360, width: 40, height: 40)
        rePwImage.image = UIImage(named: "loginPw")
        self.view.addSubview(rePwImage)

        
        reInputPw = UITextField()
        reInputPw.rframe(x: 100, y: 365, width: 200, height: 30)
        reInputPw.setBottomBorder()
        reInputPw.placeholder = "비밀번호 확인"
        reInputPw.isSecureTextEntry = true
        self.view.addSubview(reInputPw)
        
        registerBtn = UIButton()
        registerBtn.rcenter(y: 450, width: 80, height: 80, targetWidth: 375)
        registerBtn.setButton(title: "만들기", target: self, action: #selector(registerBtnAction), fontName: "tvNEnjoystoriesM", fontSize: 27, color: UIColor.mainColor)
        registerBtn.backgroundColor = UIColor(r: 246, g: 246, b: 246, alpha: 1)
        registerBtn.layer.cornerRadius = 40
        self.view.addSubview(registerBtn)
        
        
        inputName.delegate = self
        inputId.delegate = self
        inputPw.delegate = self
        reInputPw.delegate = self
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isEditing = false
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }

    
    func registerBtnAction(){
        apiManager.setApi(path: "/users/regist", method: .post, parameters: ["login_id":inputId.text!,"login_pw":inputPw.text!,"reEnterpw":reInputPw.text!,"user_name":inputName.text!,"public_range":1], header: [:])
        apiManager.requestRegisterUser { (code) in
            if code==0{
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
