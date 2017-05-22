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
    let NO_IMAGE = "http://13.124.115.238:8080/image/no_image.png"

    var user_id: Int!
    @IBOutlet weak var tableView: UITableView!
    let apiManager = ApiManager()
    let users = UserDefaults.standard
    var token : String!
    var userContentList: [UserContentList] = []
    var contentPic : [UIImage] = []
    var profilePic : UIImage!
    var userInfo : UserInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        token = users.string(forKey: "token")
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "tvNEnjoystoriesM", size: 27)!]
        print(user_id)
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
        contentPic.removeAll()
        profilePic = nil
        self.apiManager.setApi(path: "/users/\(user_id!)/info", method: .get, parameters: [:], header: ["authorization":self.token])
        self.apiManager.requestUserInfo { (userInfo) in
            self.userInfo = userInfo
            if let userInfo = self.userInfo {
                self.profilePic = UIImage(data: NSData(contentsOf: NSURL(string: userInfo.profile_dir!) as! URL)! as Data)!
            }else{
                
            }
        }
        self.apiManager.setApi(path: "/contents/\(user_id!)/info", method: .get, parameters: [:], header: ["authorization":self.token])
        self.apiManager.requestUserContents(completion: { (userlist) in
                self.userContentList = userlist
                for i in 0..<self.userContentList.count{
                    if let contentImage = self.userContentList[i].contentImage {
                        self.contentPic.append(UIImage(data: NSData(contentsOf: NSURL(string: contentImage) as! URL)! as Data)!)
                    }
                }
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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let replyVC = storyboard.instantiateViewController(withIdentifier: "ReplyVC")
        
        ReplyVC.receivedContent = self.userContentList[UserTimeLineVC.index/2-1].contentText!
        ReplyVC.receivedUserName = self.userContentList[UserTimeLineVC.index/2-1].userName!
        ReplyVC.receivedLikeCount = self.userContentList[UserTimeLineVC.index/2-1].likeCount!
        ReplyVC.receivedWriteTime = changeDate(self.userContentList[UserTimeLineVC.index/2-1].createdAt!)
        ReplyVC.receivedImg = UIImage(data: NSData(contentsOf: NSURL(string: (self.userContentList[UserTimeLineVC.index/2-1].contentImage!)) as! URL)! as Data)!
        ReplyVC.receivedProfileImg = UIImage(data: NSData(contentsOf: NSURL(string: (self.userContentList[UserTimeLineVC.index/2-1].profileImg!)) as! URL)! as Data)!
        
        
        self.present(replyVC, animated: false, completion: nil)
    }
    
    func likeBtnAction(){
        if userContentList[UserTimeLineVC.index/2 - 1].isLiked == 0 {
            userContentList[UserTimeLineVC.index/2 - 1].isLiked = 1
        }else{
            userContentList[UserTimeLineVC.index/2 - 1].isLiked = 0
        }
    }
    
    func mapBtnAction(){
        MapVC.latitude = userContentList[UserTimeLineVC.index/2 - 1].lat!
        MapVC.longitude = userContentList[UserTimeLineVC.index/2 - 1].lng!
        performSegue(withIdentifier: "mapSegue3", sender: self)
    }
    
    func reqFriendBtnAction(){
        let friendState = userContentList[0].friendState!
        print(friendState, "친구상태")
        if let userid = userInfo?.user_id! , friendState == 0{
            self.apiManager.setApi(path: "/relation/send", method: .post, parameters: ["opponent_id":userid], header: ["authorization":token])
        }else if let userid = userInfo?.user_id!, friendState == 1{
            //친구 요청 취소
            self.apiManager.setApi(path: "/relation", method: .post, parameters: ["opponent_id":userid], header: ["authorization":token])
        }else if let userid = userInfo?.user_id! , friendState == 2{
            //친구 삭제
            self.apiManager.setApi(path: "/relation", method: .post, parameters: ["opponent_id":userid], header: ["authorization":token])
        }
        apiManager.requestFriend { (code) in
            print("metacode: ",code)
        }
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
            if let userInfo = self.userInfo, indexPath.row == 0 {
                cell.userId.text = userInfo.login_id
                cell.userName.text = userInfo.user_name
                cell.mainProfileImg.image = profilePic
                
            }
            if (indexPath.row != 0) , !userContentList.isEmpty , userContentList[indexPath.row/2 - 1].userName != nil{
                cell.userlistProfileImg.image = profilePic
                cell.userlistName.text = userContentList[indexPath.row/2 - 1].userName!
                cell.createdDate.text = changeDate(userContentList[indexPath.row/2 - 1].createdAt!)
                cell.contentText.text = userContentList[indexPath.row/2 - 1].contentText!
                
                cell.contentText.sizeToFit()
                if userContentList[indexPath.row/2 - 1].contentImage != NO_IMAGE{
                    cell.contentPic.image = contentPic[indexPath.row/2 - 1]
                    cell.contentPic.y = (cell.contentText.y+cell.contentText.height+10.multiplyHeightRatio()).remultiplyHeightRatio()
                    cell.anotherBtnDown()
                }else{
                    cell.contentPic.image = nil
                    cell.anotherBtnUp()
                }
               
                cell.likeBtn.addTarget(self, action: #selector(likeBtnAction), for: .touchUpInside)
                
                cell.likeCountLabel.text = "좋아요 \(userContentList[indexPath.row/2 - 1].likeCount!)개"
                cell.likeCountLabel.sizeToFit()
                
                cell.isLiked = userContentList[indexPath.row/2 - 1].isLiked!
                cell.likeCount = userContentList[indexPath.row/2 - 1].likeCount!
                cell.content_id = userContentList[indexPath.row/2 - 1].contentId!
            }
            
            cell.commentBtn.addTarget(self, action: #selector(commentBtnAction), for: .touchUpInside)
            cell.mapBtn.addTarget(self, action: #selector(mapBtnAction), for: .touchUpInside)
            cell.addFriendButton.addTarget(self, action: #selector(reqFriendBtnAction), for: .touchUpInside)
            
            if indexPath.row == 0 {
                cell.profileHidden(false)
                
                if let id = userInfo?.login_id , id != (users.string(forKey: "userid")!) {
                    // 내가 아닌 경우
                    cell.addFriendButton.isHidden = false
                    let friendState = userContentList[indexPath.row].friendState
                    if friendState == 0{
                        cell.addFriendButton.setImage(UIImage(named: "add-contact"), for: .normal)
                        cell.friendState = 0
                    }else if friendState == 1{
                        cell.friendState = 1
                        cell.addFriendButton.setImage(UIImage(named: "reqfriend"), for: .normal)
                    }else{
                        cell.friendState = 2
                        cell.addFriendButton.setImage(UIImage(named: "alreadyfriend"), for: .normal)
                    }
                }else{
                    cell.addFriendButton.isHidden = true
                }
            }else {
                cell.profileHidden(true)
                if userContentList[indexPath.row/2 - 1].userName == nil{
                    cell.optionBtn.isHidden = true
                    cell.userlistProfileImg.isHidden = true
                }
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
                if let contentText = userContentList[indexPath.row/2 - 1].contentText {
                    textHeight.text = contentText
                    textHeight.sizeToFit()
                }
                
                picHeight.rframe(x: 0, y: (textHeight.y+textHeight.height+10), width: 375, height: 375)
                picHeight.image = UIImage(named: "gguggu")
                
                // indexPath.row 가 사진이 있으면 없으면 으로 구분한다.
                
                if let contentImage = userContentList[indexPath.row/2 - 1].contentImage , contentImage == NO_IMAGE{
                    return (textHeight.y+textHeight.height+50.multiplyHeightRatio())
                }else{
                    return (picHeight.y+picHeight.height+50.multiplyHeightRatio())
                }
                
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
