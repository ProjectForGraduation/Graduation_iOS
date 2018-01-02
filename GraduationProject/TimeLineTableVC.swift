//
//  TimeLineTableVC.swift
//  GraduationProject
//
//  Created by 윤민섭 on 2017. 3. 17..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit
class TimeLineTableVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let NO_IMAGE = "http://13.124.115.238:8080/image/no_image.png"
    var contentPic : [UIImage] = []
    var profilePic : [UIImage] = []
    var user_id: Int = 0
    
    // MARK: - static
    static var index: Int = 0
    
    // MARK: - location
    var locationManager = LocationManager()
    var locValue: Dictionary<String,Double> = [:]
    var locationTimer = Timer()
    
    // MARK: - Api
    var apiManager = ApiManager()
    var timeContentList: [ContentList] = []
    
    // userdefaults
    let users = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        updateLocation()
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "tvNEnjoystoriesM", size: 27)!]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setup()
    }
    
    // MARK: - set Table
    
    func setTableView(){
        self.tableView.rframe(x: 0, y: 0, width: 375, height: 667)
        self.tableView.bounces = false
        self.tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func setup(){
        
        contentPic.removeAll()
        profilePic.removeAll()
        timeContentList.removeAll()
        
        locationTimer = Timer.scheduledTimer(timeInterval: 300, target: self, selector: #selector(updateLocation), userInfo: nil, repeats: true)
        let userLati = Float(locValue["latitude"]!)
        let userLong = Float(locValue["longitude"]!)
        apiManager.setApi(path: "/contents/friend?lat=\(userLati)&lng=\(userLong)", method: .get, parameters: [:], header: ["authorization":users.string(forKey: "token")!])
        apiManager.requestContents { ContentList in
            self.timeContentList = ContentList
            for i in 0..<self.timeContentList.count{
                self.contentPic.append(UIImage(data: NSData(contentsOf: NSURL(string: self.timeContentList[i].contentImage!)! as URL)! as Data)!)
                self.profilePic.append(UIImage(data: NSData(contentsOf: NSURL(string: self.timeContentList[i].profileImg!)! as URL)! as Data)!)
            }
            self.tableView.reloadData()
        }
    }
    
    func updateLocation(){
        locValue = locationManager.getUserLocation()
        locationManager.setLocationDB(users.string(forKey: "token")!)
    }
    
    func openMap(){
        MapVC.latitude = timeContentList[TimeLineTableVC.index/2].lat!
        MapVC.longitude = timeContentList[TimeLineTableVC.index/2].lng!
        performSegue(withIdentifier: "MapSegue", sender: self)
    }
    
    func userBtnAction(){
        performSegue(withIdentifier: "userSegue2", sender: self)
    }
    
    func optionBtnAction(){
        apiManager.setApi(path: "contents/:contentId", method: .delete, parameters: [:], header: ["authorization":users.string(forKey: "token")!])
        contentAlert(isMine: timeContentList[TimeLineTableVC.index/2].login_id == self.users.string(forKey: "userid")!)
    }
    
    func likeBtnAction(){
        if timeContentList[TimeLineTableVC.index/2].isLiked == 0 {
            timeContentList[TimeLineTableVC.index/2].isLiked = 1
        }else{
            timeContentList[TimeLineTableVC.index/2].isLiked = 0
        }
    }
    
    func commentBtnAction(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let replyVC = storyboard.instantiateViewController(withIdentifier: "ReplyVC")
        
        ReplyVC.receivedContent = self.timeContentList[TimeLineTableVC.index/2].contentText!
        ReplyVC.receivedUserName = self.timeContentList[TimeLineTableVC.index/2].userName!
        ReplyVC.receivedLikeCount = self.timeContentList[TimeLineTableVC.index/2].likeCount!
        ReplyVC.receivedWriteTime = changeDate(self.timeContentList[TimeLineTableVC.index/2].createdAt!)
        ReplyVC.receivedImg = UIImage(data: NSData(contentsOf: NSURL(string: (self.timeContentList[TimeLineTableVC.index/2].contentImage!))! as URL)! as Data)!
        ReplyVC.receivedProfileImg = UIImage(data: NSData(contentsOf: NSURL(string: (self.timeContentList[TimeLineTableVC.index/2].profileImg!))! as URL)! as Data)!
        
        
        self.present(replyVC, animated: false, completion: nil)
    }
    
    
    func contentAlert(isMine : Bool){
        
        let alertView = UIAlertController(title: "", message: "이 글에 대하여", preferredStyle: .actionSheet)
        
        let removeContent = UIAlertAction(title: "게시물 삭제", style: UIAlertActionStyle.destructive, handler: { UIAlertAction in
            let contentId = (self.timeContentList[TimeLineTableVC.index/2].contentId!)
            self.apiManager.setApi(path: "/contents/\(contentId)", method: .delete, parameters: [:], header: ["authorization":self.users.string(forKey: "token")!])
            self.apiManager.requestDeleteContents(completion: { (code) in
                if(code == 0){
                    self.setup()
                }
            })
            alertView.dismiss(animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (_) in }
        let reportAction = UIAlertAction(title: "신고하기", style: .destructive) { (_) in }
        
        if isMine{
            alertView.addAction(removeContent)
        } else {
            alertView.addAction(reportAction)
        }
        
        alertView.addAction(cancelAction)
        
        alertWindow(alertView: alertView)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userSegue2" {
            let des = segue.destination as! UINavigationController
            let target = des.topViewController as! UserTimeLineVC
            target.user_id = timeContentList[TimeLineTableVC.index/2].userId!
        }
    }
}


// MARK: - extension tableVC

extension TimeLineTableVC: UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeContentList.count*2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row % 2 {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "timelineCell", for: indexPath) as! TimeLineCell
            cell.selectionStyle = .none
            cell.index = indexPath.row
            cell.content_id = timeContentList[indexPath.row/2].contentId!
            cell.user_id = timeContentList[indexPath.row/2].userId!
            //유저 프로필 사진
            cell.profileImg.image = profilePic[indexPath.row/2]
            cell.profileImg.addAction(target: self, action: #selector(userBtnAction))
            // 좋아요
            cell.isLiked = timeContentList[indexPath.row/2].isLiked!
            cell.likeCount = timeContentList[indexPath.row/2].likeCount!
            // 옵션
            cell.optionBtn.addTarget(self, action: #selector(optionBtnAction), for: .touchUpInside)
            
            
            
            cell.userName.setTitle(timeContentList[indexPath.row/2].userName!, for: .normal)
            cell.userName.contentHorizontalAlignment = .left
            cell.userName.addTarget(self, action: #selector(userBtnAction), for: .touchUpInside)
            
            cell.contentText.text = timeContentList[indexPath.row/2].contentText!
            cell.contentText.sizeToFit()
            
            cell.mapBtn.addTarget(self, action: #selector(openMap), for: .touchUpInside)
            
            if timeContentList[indexPath.row/2].contentImage != NO_IMAGE{
                cell.contentPic.image = contentPic[indexPath.row/2]
                cell.contentPic.y = (cell.contentText.y+cell.contentText.height+10.multiplyHeightRatio()).remultiplyHeightRatio()
                cell.anotherBtnDown()
            }else{
                cell.contentPic.image = nil
                cell.anotherBtnUp()
            }
            cell.likeBtn.addTarget(self, action: #selector(likeBtnAction), for: .touchUpInside)
            
            cell.content_id = timeContentList[indexPath.row/2].contentId!
            cell.likeCountLabel.text = "좋아요 \(timeContentList[indexPath.row/2].likeCount!)개"
            cell.likeCountLabel.sizeToFit()
            cell.commentBtn.addTarget(self, action: #selector(commentBtnAction), for: .touchUpInside)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "spaceCell", for: indexPath) as! SpaceCell
            cell.selectionStyle = .none
            return cell
        }
    }
}

extension TimeLineTableVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row % 2 {
        case 0:
            let textHeight = UILabel()
            let picHeight = UIImageView()
            textHeight.rframe(x: 10, y: 60, width: 375, height: 0)
            textHeight.setLabel(text: "", align: .left, fontName: "AppleSDGothicNeo-Medium", fontSize: 11, color: UIColor.black)
            textHeight.text = "윤민섭"
            textHeight.sizeToFit()
            
            picHeight.rframe(x: 0, y: (textHeight.y+textHeight.height+10).remultiplyHeightRatio(), width: 375, height: 375)
            picHeight.image = UIImage(named: "gguggu")
            
            if timeContentList[indexPath.row/2].contentImage! == NO_IMAGE {
                return (textHeight.y+textHeight.height+50.multiplyHeightRatio())
            }else{
                return (picHeight.y+picHeight.height+50.multiplyHeightRatio())
            }
            
        default:
            return 7.multiplyHeightRatio()
        }
    }
}

