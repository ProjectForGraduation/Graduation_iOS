//
//  MyListVC.swift
//  GraduationProject
//
//  Created by 윤민섭 on 2017. 3. 17..
//  Copyright © 2017년 윤민섭. All rights reserved.
//


import UIKit
import Fusuma

class UserTimeLineVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    static var index: Int = 0
    
    var user_id: Int = 0
    @IBOutlet weak var tableView: UITableView!
    let apiManager = ApiManager()
    let users = UserDefaults.standard
    var token : String!
    var userContentList: [UserContentList] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        token = users.string(forKey: "token")
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "tvNEnjoystoriesM", size: 27)!]
        setTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUpView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setTableView(){
        self.tableView.rframe(x: 0, y: 0, width: 375, height: 667)
        self.tableView.bounces = false
        self.tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func setUpView(){
        
        self.apiManager.setApi(path: "/contents/\(user_id)/info", method: .get, parameters: [:], header: ["authorization":self.token])
        self.apiManager.requestUserContents(completion: { (userlist) in
                self.userContentList = userlist
                self.tableView.reloadData()
        })
    }
    

    
    func changeDate(_ date: String)->String{
        let year = date.substring(to: date.index(date.startIndex, offsetBy: 4))
        let month = date.substring(with: date.index(date.startIndex, offsetBy:5)..<date.index(date.startIndex, offsetBy:7))
        let day = date.substring(with: date.index(date.startIndex, offsetBy:8)..<date.index(date.startIndex, offsetBy:10))
        let date = year+"년 " + "\(Int(month)!)" + "월 " + "\(Int(day)!)" + "일"
        return date
    }
    
    func commentBtnAction(){

    }
    @IBAction func backBtn(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
}

extension UserTimeLineVC {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2+userContentList.count*2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row % 2 {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "usertimeline", for: indexPath) as! UserListCell
            cell.selectionStyle = .none
            cell.index = indexPath.row
            if indexPath.row == 0 ,!userContentList.isEmpty{
                cell.userId.text = "\(userContentList[0].userId)"
                cell.userName.text = userContentList[0].userName
                if userContentList[0].profileImg != "0"{
                    cell.mainProfileImg.image = UIImage(data: NSData(contentsOf: NSURL(string: (userContentList[0].profileImg)!) as! URL)! as Data)!
                }
            }
            
            if (indexPath.row != 0) , !userContentList.isEmpty{
                if userContentList[indexPath.row/2 - 1].profileImg != "0"{
                    cell.userlistProfileImg.image = UIImage(data: NSData(contentsOf: NSURL(string: userContentList[indexPath.row/2 - 1].profileImg!) as! URL)! as Data)!
                }
                cell.userlistName.text = userContentList[indexPath.row/2 - 1].userName!
                cell.createdDate.text = changeDate(userContentList[indexPath.row/2 - 1].createdAt!)
                cell.contentText.text = userContentList[indexPath.row/2 - 1].contentText!
                
                
                cell.contentText.sizeToFit()
                if userContentList[indexPath.row/2 - 1].contentImage != "0"{
                    cell.contentPic.image = UIImage(data: NSData(contentsOf: NSURL(string: userContentList[indexPath.row/2 - 1].contentImage!) as! URL)! as Data)!
                    cell.contentPic.y = (cell.contentText.y+cell.contentText.height+10.multiplyHeightRatio()).remultiplyHeightRatio()
                    cell.anotherBtnDown()
                }else{
                    cell.contentPic.image = nil
                    cell.anotherBtnUp()
                }
            }
            
            cell.commentBtn.addTarget(self, action: #selector(commentBtnAction), for: .touchUpInside)
            
            if indexPath.row == 0 {
                cell.profileHidden(false)
            }else {
                cell.profileHidden(true)
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "spaceCell", for: indexPath) as! SpaceCell
            cell.selectionStyle = .none
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row % 2 {
        case 0:
            if indexPath.row == 0{
                return 160.multiplyHeightRatio()
            }else{
                let textHeight = UILabel()
                let picHeight = UIImageView()
                textHeight.rframe(x: 10, y: 50, width: 375, height: 0)
                textHeight.setLabel(text: "", align: .left, fontName: "AppleSDGothicNeo-Medium", fontSize: 11, color: UIColor.black)
                textHeight.text = userContentList[indexPath.row/2 - 1].contentText!
                textHeight.sizeToFit()
                
                picHeight.rframe(x: 0, y: (textHeight.y+textHeight.height+10), width: 375, height: 375)
                picHeight.image = UIImage(named: "gguggu")
                
                // indexPath.row 가 사진이 있으면 없으면 으로 구분한다.
                
                return (picHeight.y+picHeight.height+50.multiplyHeightRatio())
                
            }
        default:
            return 7
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //performSegue(withIdentifier: "segueToReplyVC", sender: self)
        
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //let replyContentVC = storyboard.instantiateViewController(withIdentifier: "ReplyVC")
        
        
        
        //        SelectListViewController.receivedCid = self.photos[indexPath.item].contentId
        //        SelectListViewController.receivedCimg = self.photos[indexPath.item].image
        //        SelectListViewController.receivedRange = 0
        //        SelectListViewController.receivedIndex = indexPath.item
        
        //self.present(replyContentVC, animated: false, completion: nil)
        
    }
    
}
