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
        if let token = users.string(forKey: "token"), token != "RE_LOGIN" {
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
            setup()
        }
        
    }

    func setup(){
        
        mainLabel = UILabel()
        mainLabel.rcenter(y: 250, width: 375, height: 40, targetWidth: 375)
        mainLabel.setLabel(text: "지금 여기 우리", align: .center, fontName: "tvNEnjoystoriesM", fontSize: 43, color: #colorLiteral(red: 0.2374400198, green: 0.6492436528, blue: 0, alpha: 1))
        self.view.addSubview(mainLabel)
        
        subLabel = UILabel()
        subLabel.rcenter(y: 290, width: 375, height: 100, targetWidth: 375)
        subLabel.setLabel(text: "내 주변 사람들과 소통할 수 있는 위치 기반 SNS", align: .center, fontName: "tvNEnjoystoriesM", fontSize: 21, color: #colorLiteral(red: 0.2374400198, green: 0.6492436528, blue: 0, alpha: 1))
        subLabel.numberOfLines = 0
        self.view.addSubview(subLabel)
        
        registerBtn = UIButton()
        registerBtn.rframe(x: 70, y: 420, width: 100, height: 50)
        registerBtn.setTitle("계정 만들기", for: .normal)
        registerBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        registerBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        registerBtn.backgroundColor = #colorLiteral(red: 0.2374400198, green: 0.6492436528, blue: 0, alpha: 1)
        registerBtn.layer.cornerRadius = 15
        registerBtn.addAction(target: self, action: #selector(registerBtnAction))
        self.view.addSubview(registerBtn)
        
        loginBtn = UIButton()
        loginBtn.rframe(x: 200, y: 420, width: 100, height: 50)
        loginBtn.setTitle("로그인 하기", for: .normal)
        loginBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        loginBtn.backgroundColor = #colorLiteral(red: 0.2374400198, green: 0.6492436528, blue: 0, alpha: 1)
        loginBtn.layer.cornerRadius = 15
        loginBtn.addAction(target: self, action: #selector(loginBtnAction))
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
            self.present(loginVC, animated: false, completion: nil)
        })
        
        alertView.addAction(action)
        
        alertWindow(alertView: alertView)
    }
}
