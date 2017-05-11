//
//  MyListVC.swift
//  GraduationProject
//
//  Created by 윤민섭 on 2017. 3. 17..
//  Copyright © 2017년 윤민섭. All rights reserved.
//


import UIKit
import Fusuma

class UserTimeLineVC: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var userProfileImg: UIImageView!
    @IBOutlet weak var userView: UIView!

    @IBOutlet weak var userId: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var friendBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spaceView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "tvNEnjoystoriesM", size: 27)!]
        viewSetUp()
        tableViewSet()
    }
    
    func viewSetUp(){
        
        userProfileImg.rcenter(y: 10, width: 100, height: 100, targetWidth: 375)
        userProfileImg.image = UIImage(named: "default")
        userProfileImg.layer.masksToBounds = false
        userProfileImg.layer.cornerRadius = 50.multiplyWidthRatio()
        userProfileImg.clipsToBounds = true
        
        userId.rcenter(y: 120, width: 375, height: 14, targetWidth: 375)
        userId.setLabel(text: "yoonmssssss", align: .center, fontName: "AppleSDGothicNeo-Medium", fontSize: 15, color: UIColor.black)
        
        userName.rcenter(y: 136, width: 375, height: 12, targetWidth: 375)
        userName.setLabel(text: "윤민섭", align: .center, fontName: "AppleSDGothicNeo-Medium", fontSize: 13, color: UIColor.black)
        spaceView.rcenter(y: 152, width: 375, height: 6, targetWidth: 375)
        
        userView.rcenter(y: 0, width: 375, height: 159, targetWidth: 375)
    }
    
    func tableViewSet(){
        self.tableView.rframe(x: 0, y: 0, width: 375, height: 667)
        self.tableView.bounces = false
        self.tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
}

extension UserTimeLineVC{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "usertimeline", for: indexPath) as! UserListCell
        cell.textLabel?.text = "1"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
