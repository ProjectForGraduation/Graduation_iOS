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
    var inputId : UITextField!
    var inputPw : UITextField!
    var loginBtn : UIButton!
    
    let apiManager = ApiManager()
    let users = UserDefaults.standard
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "tvNEnjoystoriesM", size: 27)!]
        setUpView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpView(){
        idImage = UIImageView()
        idImage.rframe(x: 52, y: 200, width: 38, height: 38)
        idImage.image = UIImage(named: "loginID")
        self.view.addSubview(idImage)
        
        inputId = UITextField()
        inputId.rframe(x: 100, y: 205, width: 200, height: 30)
        inputId.setBottomBorder()
        inputId.placeholder = "아이디"
        self.view.addSubview(inputId)
        
        
        pwImage = UIImageView()
        pwImage.rframe(x: 50, y: 270, width: 40, height: 40)
        pwImage.image = UIImage(named: "loginPw")
        self.view.addSubview(pwImage)
        
        inputPw = UITextField()
        inputPw.rframe(x: 100, y: 275, width: 200, height: 30)
        inputPw.setBottomBorder()
        inputPw.placeholder = "비밀번호"
        inputPw.isSecureTextEntry = true
        self.view.addSubview(inputPw)
        
        
        loginBtn = UIButton()
        loginBtn.rcenter(y: 340, width: 80, height: 80, targetWidth: 375)
        loginBtn.setButton(title: "로그인", target: self, action: #selector(loginBtnAction), fontName: "tvNEnjoystoriesM", fontSize: 27, color: UIColor.mainColor)
        loginBtn.backgroundColor = UIColor(r: 246, g: 246, b: 246, alpha: 1)
        loginBtn.layer.cornerRadius = 40
        self.view.addSubview(loginBtn)
        
        
        inputId.delegate = self
        inputPw.delegate = self
        
    }
    
    func loginBtnAction(){
        apiManager.setApi(path: "/users/login", method: .post, parameters: ["login_id":inputId.text!,"login_pw":inputPw.text!], header: [:])
        apiManager.requestLogin { (meta, token) in
            if meta == 0 {
                self.users.set(token, forKey: "token")
                self.performSegue(withIdentifier: "mainSegue", sender: self)
            }else{
                self.basicAlert(title: "오류!", message: "아이디, 비밀번호를 확인해주세요.", false)
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
    
    func basicAlert(title : String,message : String, _ agree: Bool){
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "네", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            alertView.dismiss(animated: true, completion: nil)
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}