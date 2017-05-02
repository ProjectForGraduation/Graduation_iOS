//
//  PreViewVC.swift
//  GraduationProject
//
//  Created by 윤민섭 on 2017. 4. 25..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class PreViewVC: UIViewController {

    let apiManager = ApiManager()
    
    var mainImage : UIImageView!
    var mainLabel : UILabel!
    var subLabel : UILabel!
    var registerBtn : UIButton!
    var loginBtn : UIButton!
    var users = UserDefaults.standard
    var token : String?
    var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let token = users.string(forKey: "token") {
            apiManager.setApi(path: "/token", method: .get, parameters: [:], header: ["authorization":token])
            
            self.apiManager.requestToken { (token) in
                if token != "OPEN_LOGINVC"{
                    self.users.set(token, forKey: "token")
                    self.performSegue(withIdentifier: "validTokenSegue", sender: self)
                }else{
                    self.tokenInvalidAlert()
                }
            }
        }else{
            setUpView()
        }
        
        // Do any additional setup after loading the view.
    }

    func setUpView(){
        mainImage = UIImageView()
        mainImage.rcenter(y: 160, width: 120, height: 140, targetWidth: 375)
        mainImage.image = UIImage(named: "pic")
        self.view.addSubview(mainImage)
        
        mainLabel = UILabel()
        mainLabel.rcenter(y: 310, width: 375, height: 40, targetWidth: 375)
        mainLabel.setLabel(text: "지금 여기 우리", align: .center, fontName: "tvNEnjoystoriesM", fontSize: 40, color: UIColor.mainColor)
        self.view.addSubview(mainLabel)
        
        subLabel = UILabel()
        subLabel.rcenter(y: 350, width: 375, height: 100, targetWidth: 375)
        subLabel.setLabel(text: "내 주변 사람들과 소통할 수 있는\n 위치 기반 SNS", align: .center, fontName: "tvNEnjoystoriesL", fontSize: 23, color: UIColor.mainColor)
        subLabel.numberOfLines = 0
        self.view.addSubview(subLabel)
        
        registerBtn = UIButton()
        registerBtn.rframe(x: 70, y: 470, width: 100, height: 50)
        registerBtn.setButton(title: "계정 만들기", target: self, action: #selector(registerBtnAction), fontName: "tvNEnjoystoriesM", fontSize: 27, color: UIColor.mainColor)
        registerBtn.backgroundColor = UIColor(r: 246, g: 246, b: 246, alpha: 1)
        registerBtn.layer.cornerRadius = 15
        self.view.addSubview(registerBtn)
        
        loginBtn = UIButton()
        loginBtn.rframe(x: 200, y: 470, width: 100, height: 50)
        loginBtn.setButton(title: "로그인 하기", target: self, action: #selector(loginBtnAction), fontName: "tvNEnjoystoriesM", fontSize: 27, color: UIColor.mainColor)
        loginBtn.backgroundColor = UIColor(r: 246, g: 246, b: 246, alpha: 1)
        loginBtn.layer.cornerRadius = 15
        self.view.addSubview(loginBtn)
        
    }
    
    
    func registerBtnAction(){
        self.performSegue(withIdentifier: "registerSegue", sender: self)
    }
    
    func loginBtnAction(){
        self.performSegue(withIdentifier: "loginSegue", sender: self)
    }
    
    func tokenInvalidAlert(){
        let alertView = UIAlertController(title: "로그인 만료", message: "다시 로그인 해주세요.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")
            self.window?.rootViewController = loginVC
            self.window?.makeKeyAndVisible()
            
        })
        
        
        
        alertView.addAction(action)
        
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
