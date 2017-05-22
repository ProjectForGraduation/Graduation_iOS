//
//  MyListVC.swift
//  GraduationProject
//
//  Created by 윤민섭 on 2017. 3. 17..
//  Copyright © 2017년 윤민섭. All rights reserved.
//


import UIKit
import Fusuma

class MyListVC: UIViewController,UITableViewDataSource,UITableViewDelegate,FusumaDelegate {
    
    static var index: Int = 0
    let NO_IMAGE = "http://13.124.115.238:8080/image/no_image.png"
    
    @IBOutlet weak var tableView: UITableView!
    let apiManager = ApiManager()
    let users = UserDefaults.standard
    var token : String!
    var myContentList: [UserContentList] = []
    var userInfo : UserInfo?
    var contentPic : [UIImage] = []
    var profilePic : UIImage!
    
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
        contentPic.removeAll()
        profilePic = nil
        
        self.apiManager.setApi(path: "/users/my", method: .get, parameters: [:], header: ["authorization":self.token])
        apiManager.requestUserInfo { (userInfo) in
            self.userInfo = userInfo
            let userId = self.userInfo!.user_id!
            self.profilePic = UIImage(data: NSData(contentsOf: NSURL(string: (self.userInfo!.profile_dir)!) as! URL)! as Data)!
            self.apiManager.setApi(path: "/contents/\(userId)/info", method: .get, parameters: [:], header: ["authorization":self.token])
            self.apiManager.requestUserContents(completion: { (mylist) in
                self.myContentList = mylist
                for i in 0..<self.myContentList.count{
                    if let contentImage = self.myContentList[i].contentImage {
                        self.contentPic.append(UIImage(data: NSData(contentsOf: NSURL(string: contentImage) as! URL)! as Data)!)
                    }
                }
                self.tableView.reloadData()
            })
        }
        
    }
    
    func changeProfileImage(){
        let fusuma = FusumaViewController()
        
        fusuma.delegate = self
        fusuma.cropHeightRatio = 1.0
        fusumaCropImage = false
        fusumaTintColor = UIColor.darkGray
        fusumaBackgroundColor = UIColor.darkGray
        
        self.present(fusuma, animated: false, completion: nil)
        
    }
    
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        switch source {
        case .camera:
            print("Image captured from Camera")
        case .library:
            print("Image selected from Camera Roll")
        default:
            print("Image selected")
        }
        
        apiManager.setApi(path: "/users/profile", method: .post, parameters: [:], header: ["authorization":users.string(forKey: "token")!])
        
        apiManager.requestChangeProfileImage(resizing(image)!)
        setUpView()
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        print("video completed and output to file: \(fileURL)")
        //self.fileUrlLabel.text = "file output to: \(fileURL.absoluteString)"
    }
    
    func fusumaDismissedWithImage(_ image: UIImage, source: FusumaMode) {
        switch source {
        case .camera:
            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
            break
        case .library: break
            
        default: break
            
        }
        
        //performSegue(withIdentifier: "writeSegue", sender: self)
    }
    @IBAction func logoutBtnAction(_ sender: UIButton) {
        apiManager.setApi(path: "/users/:id", method: .delete, parameters: [:], header: ["authorization":token])
        apiManager.requestLogout { (code) in
            if code == 0{
                self.users.set("RE_LOGIN", forKey: "token")
                //present id : preview
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let PreViewVC = storyboard.instantiateViewController(withIdentifier: "preview")
                self.present(PreViewVC, animated: false, completion: nil)

            }
        }
    }
    
    func fusumaCameraRollUnauthorized() {
        
        let alert = UIAlertController(title: "Access Requested", message: "Saving image needs to access your photo album", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (action) -> Void in
            
            if let url = URL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.shared.openURL(url)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func fusumaClosed() {
        
        print("Called when the close button is pressed")
        
    }
    
    
    func changeDate(_ date: String)->String{
        let year = date.substring(to: date.index(date.startIndex, offsetBy: 4))
        let month = date.substring(with: date.index(date.startIndex, offsetBy:5)..<date.index(date.startIndex, offsetBy:7))
        let day = date.substring(with: date.index(date.startIndex, offsetBy:8)..<date.index(date.startIndex, offsetBy:10))
        let date = year+"년 " + "\(Int(month)!)" + "월 " + "\(Int(day)!)" + "일"
        return date
    }
    
    func resizing(_ image: UIImage) -> Data?{
        let resizedWidthImage = image.resized(toWidth: 1080)
        let resizedData = UIImageJPEGRepresentation(resizedWidthImage!, 0.25)
        return resizedData
    }
    
    func commentBtnAction(){

        let liked = myContentList[MyListVC.index/2 - 1].isLiked!
        print(liked)

        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let replyVC = storyboard.instantiateViewController(withIdentifier: "ReplyVC")
        
        ReplyVC.receivedContent = self.myContentList[MyListVC.index/2-1].contentText!
        ReplyVC.receivedUserName = self.myContentList[MyListVC.index/2-1].userName!
        ReplyVC.receivedLikeCount = self.myContentList[MyListVC.index/2-1].likeCount!
        ReplyVC.receivedWriteTime = changeDate(self.myContentList[MyListVC.index/2-1].createdAt!)
        ReplyVC.receivedImg = UIImage(data: NSData(contentsOf: NSURL(string: (self.myContentList[MyListVC.index/2-1].contentImage!)) as! URL)! as Data)!
        ReplyVC.receivedProfileImg = UIImage(data: NSData(contentsOf: NSURL(string: (self.myContentList[MyListVC.index/2-1].profileImg!)) as! URL)! as Data)!
        
        ReplyVC.receivedContentId = self.myContentList[MyListVC.index/2-1].contentId!
        ReplyVC.receivedReplyCount = self.myContentList[MyListVC.index/2-1].replyCount!
        ReplyVC.receivedIsLiked = self.myContentList[MyListVC.index/2-1].isLiked!
        
        
        self.present(replyVC, animated: false, completion: nil)
        
    }
    
    func likeBtnAction(){
        let liked = myContentList[MyListVC.index/2 - 1].isLiked!
        if liked == 0 {
            myContentList[MyListVC.index/2 - 1].isLiked = 1
            myContentList[MyListVC.index/2 - 1].likeCount! += 1
        }else{
            myContentList[MyListVC.index/2 - 1].isLiked = 0
            myContentList[MyListVC.index/2 - 1].likeCount! -= 1
        }
        
    }
    
    func mapBtnAction(){
        MapVC.latitude = myContentList[MyListVC.index/2 - 1].lat!
        MapVC.longitude = myContentList[MyListVC.index/2 - 1].lng!
        performSegue(withIdentifier: "mapSegue3", sender: self)
        
    }
    
    func optionBtnAction(){
        contentAlert()
    }
    
    func contentAlert(){
        
        let alertView = UIAlertController(title: "", message: "이 글에 대하여", preferredStyle: .actionSheet)
        
        let removeContent = UIAlertAction(title: "게시물 삭제", style: UIAlertActionStyle.destructive, handler: { (UIAlertAction) in
            let contentId = (self.myContentList[MyListVC.index].contentId!)
            self.apiManager.setApi(path: "/contents/\(contentId)", method: .delete, parameters: [:], header: ["authorization":self.users.string(forKey: "token")!])
            self.apiManager.requestDeleteContents(completion: { (code) in
                print(code)
            })
            self.tableView.reloadData()
            alertView.dismiss(animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (_) in }
        
        alertView.addAction(cancelAction)
        alertView.addAction(removeContent)
        
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindowLevelAlert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alertView, animated: true, completion: nil)
        
    }
}

extension MyListVC {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2+myContentList.count*2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row % 2 {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "mytimeline", for: indexPath) as! MyListCell
            cell.selectionStyle = .none
            cell.index = indexPath.row
            if userInfo != nil{
                cell.myId.text = userInfo?.login_id
                cell.myName.text = userInfo?.user_name
                cell.mainProfileImg.image = profilePic
                
            }
            
            if (indexPath.row != 0) , !myContentList.isEmpty, myContentList[indexPath.row/2 - 1].userName != nil{
                cell.mylistProfileImg.image = profilePic
                cell.mylistName.text = myContentList[indexPath.row/2 - 1].userName!
                cell.createdDate.text = changeDate(myContentList[indexPath.row/2 - 1].createdAt!)
                cell.contentText.text = myContentList[indexPath.row/2 - 1].contentText!
                
                
                cell.contentText.sizeToFit()
                if myContentList[indexPath.row/2 - 1].contentImage != NO_IMAGE{
                    cell.contentPic.image = contentPic[indexPath.row/2 - 1]
                    cell.contentPic.y = (cell.contentText.y+cell.contentText.height+10.multiplyHeightRatio()).remultiplyHeightRatio()
                    cell.anotherBtnDown()
                }else{
                    cell.contentPic.image = nil
                    cell.anotherBtnUp()
                }
                
                cell.likeBtn.addTarget(self, action: #selector(likeBtnAction), for: .touchUpInside)
                
                cell.likeCountLabel.text = "좋아요 \(myContentList[indexPath.row/2 - 1].likeCount!)개"
                cell.likeCountLabel.sizeToFit()
                
                cell.isLiked = myContentList[indexPath.row/2 - 1].isLiked!
                cell.likeCount = myContentList[indexPath.row/2 - 1].likeCount!
                cell.content_id = myContentList[indexPath.row/2 - 1].contentId!
            }
            cell.optionBtn.addAction(target: self, action: #selector(optionBtnAction))
            cell.mainProfileImg.addAction(target: self, action: #selector(changeProfileImage))
            cell.commentBtn.addTarget(self, action: #selector(commentBtnAction), for: .touchUpInside)
            cell.mapBtn.addTarget(self, action: #selector(mapBtnAction), for: .touchUpInside)
            
            if indexPath.row == 0 {
                cell.profileHidden(false)
            }else {
                cell.profileHidden(true)
                if myContentList[indexPath.row/2 - 1].userName == nil{
                    cell.optionBtn.isHidden = true
                    cell.mylistProfileImg.isHidden = true
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
                if let contentText = myContentList[indexPath.row/2 - 1].contentText {
                    textHeight.text = contentText
                    textHeight.sizeToFit()
                }
                
                picHeight.rframe(x: 0, y: (textHeight.y+textHeight.height+10), width: 375, height: 375)
                picHeight.image = UIImage(named: "gguggu")
                
                // indexPath.row 가 사진이 있으면 없으면 으로 구분한다.
                
                if let contentImage = myContentList[indexPath.row/2 - 1].contentImage , contentImage == NO_IMAGE {
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
