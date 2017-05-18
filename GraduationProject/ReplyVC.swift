//
//  ReplyContentVC.swift
//  GraduationProject
//
//  Created by 전한경 on 2017. 5. 4..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class ReplyVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var receivedView: UIView!
    
    @IBOutlet weak var bottomBar: UIToolbar!
    
    @IBOutlet weak var replyTextField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    var navBar = UINavigationBar()
    var profileImg = UIImageView()
    var userName = UILabel()
    var writeTime = UILabel()
    var contentImg = UIImageView()
    var content = UITextView()
    
    
    var likeLabel = UILabel()
    var replyLabel = UILabel()
    
    var likeButton = UIButton()
    var likeInfoLabel = UILabel()
    
    static var receivedProfileImg = UIImage(named:"gguggu")
    static var receivedUserName = "신꾸꾸"
    static var receivedWriteTime = "20160731"
    static var receivedContent = "안녕하세요안녕하세요안녕하세요"
    static var receivedImg = UIImage(named:"gguggu")
    static var receivedLikeCount = 30
    static var receivedReplyCount = 22
    static var receivedIsLiked = 0
    
    static var receivedContentId = 0
    
    var apiManager2 = ApiManager2()
    
    
    let users = UserDefaults.standard
    //
    var emojiFlag : Int = 0
    var likeFlag : Int = ReplyVC.receivedIsLiked
    var hasImgFlag : Bool = true
    
    var replyContent: [ReplyList] = []//= [ReplyList(profileImg: "",userName: "한경이",reply: "안녕하세요1",writeTime: "20160726"),ReplyList(profileImg: "",userName: "한경이2",reply: "안녕하세요2",writeTime: "20160727"),ReplyList(profileImg: "",userName: "한경이3",reply: "안녕하세요3",writeTime: "20160728"),ReplyList(profileImg: "",userName: "한경이4",reply: "안녕하세요4",writeTime: "20160728"),ReplyList(profileImg: "",userName: "한경이5",reply: "안녕하세요5",writeTime: "20160728")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBasicView()
        setContents()
        setTableView()
        
        
        replyTextField.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        loadReply()
        //tableView.reloadData()
        
    }
    
    func loadReply(){
        
        apiManager2.setApi(path: "/contents/\(ReplyVC.receivedContentId)/reply", method: .get, parameters: [:], header: ["authorization":users.string(forKey: "token")!])
        apiManager2.getReply { (replyContents) in
            self.replyContent = replyContents
            self.tableView.reloadData()
            //댓글 ui 갱신
            //ReplyVC.receivedReplyCount = replyContent[0
        }
        
        //reply get func
        //1.model create
        //2.load in model and make completion
        //3. 전역모델리스트에 할당 끝~
        
        //4. 글쓰면 모델삭제하고 다시 로드하고 reload해줌..
    
    }
    func setBasicView(){
        
        
        navBar.rframe(x: 0, y: 0, width: 375, height: 66)
        
        let navItem = UINavigationItem(title: "자세히 보기")
        let doneItem = UIBarButtonItem(title: "뒤로가기", style: UIBarButtonItemStyle.plain, target: self, action: #selector(leftButtonAction))
        doneItem.tintColor = UIColor.black
        navItem.leftBarButtonItem = doneItem
        navBar.setItems([navItem], animated: false)
        
        
        profileImg.rframe(x: 10, y: 10, width: 70, height: 70)
        profileImg.image = UIImage(named: "default")
        profileImg.layer.masksToBounds = false
        profileImg.layer.cornerRadius = 35.multiplyWidthRatio()
        profileImg.clipsToBounds = true
        
        userName.rframe(x: 95, y: 20, width: 50, height: 14)
        userName.setLabel(text: "", align: .left, fontName: "AppleSDGothicNeo-Bold", fontSize: 14, color: UIColor.black)
        
        
        writeTime.rframe(x: 95, y: 40, width: 70, height: 10)
        writeTime.setLabel(text: "", align: .left, fontName: "AppleSDGothicNeo-Medium", fontSize: 10, color: UIColor.black)
        
        
        if hasImgFlag{
            receivedView.rframe(x: 0, y: 0, width: 375, height: 650)
            contentImg.rframe(x: 37.5, y: 100, width: 300, height: 300)
            content.rframe(x: 20, y: 450, width: 335, height: 100)
            likeLabel.rframe(x: 230, y: 580, width: 70, height: 12)
            replyLabel.rframe(x: 300, y: 580, width: 70, height: 12)
            drawLine(startX: 0, startY: 600.multiplyHeightRatio(), width: 375.multiplyWidthRatio(), height: 1, border: false, color: UIColor.blue
                ,targetView: receivedView)
            likeButton.rframe(x: 25, y: 615, width: 20, height: 23)
            likeInfoLabel.rframe(x: 50, y: 620, width: 40, height: 12)
            drawLine(startX: 0, startY: 650.multiplyHeightRatio(), width: 375.multiplyWidthRatio(), height: 1, border: false, color: UIColor.blue
                ,targetView: receivedView)
        }else{
            receivedView.rframe(x: 0, y: 0, width: 375, height: 500)
            content.rframe(x: 20, y: 100, width: 335, height: 100)
            likeLabel.rframe(x: 230, y: 430, width: 70, height: 12)
            replyLabel.rframe(x: 300, y: 430, width: 70, height: 12)
            drawLine(startX: 0, startY: 450.multiplyHeightRatio(), width: 375.multiplyWidthRatio(), height: 1, border: false, color: UIColor.blue
                ,targetView: receivedView)
            likeButton.rframe(x: 25, y: 465, width: 20, height: 23)
            likeInfoLabel.rframe(x: 50, y: 470, width: 40, height: 12)
            drawLine(startX: 0, startY: 500.multiplyHeightRatio(), width: 375.multiplyWidthRatio(), height: 1, border: false, color: UIColor.blue
                ,targetView: receivedView)
        }
        
        contentImg.image = ReplyVC.receivedImg
        
        content.setTextView(fontName: "AppleSDGothicNeo-Medium", size: 12)
        content.textColor = UIColor.black
        //content.layer.borderWidth = 1
        content.isUserInteractionEnabled = false
        
        
        likeLabel.setLabel(text: "좋아요 \(ReplyVC.receivedLikeCount)개", align: .left, fontName: "AppleSDGothicNeo-Medium", fontSize: 12, color:UIColor(red: 191/255, green: 196/255, blue: 204/255, alpha: 1.0))
        
        
        replyLabel.setLabel(text: "댓글 \(ReplyVC.receivedReplyCount)개", align: .left, fontName: "AppleSDGothicNeo-Medium", fontSize: 12, color:UIColor(red: 191/255, green: 196/255, blue: 204/255, alpha: 1.0))
        
        if likeFlag == 0{
            likeButton.setButton(imageName: "like", target: self, action: #selector(likeButtonAction))
        }else{
            likeButton.setButton(imageName: "likeFill", target: self, action: #selector(likeButtonAction))
        }
        
        likeInfoLabel.setLabel(text: "좋아요", align: .left, fontName: "AppleSDGothicNeo-Medium", fontSize: 12, color: UIColor(red: 191/255, green: 196/255, blue: 204/255, alpha: 1.0))
        
        
        view.addSubview(navBar)
        
        receivedView.addSubview(profileImg)
        receivedView.addSubview(userName)
        receivedView.addSubview(writeTime)
        receivedView.addSubview(contentImg)
        receivedView.addSubview(content)
        receivedView.addSubview(likeLabel)
        receivedView.addSubview(replyLabel)
        receivedView.addSubview(likeButton)
        receivedView.addSubview(likeInfoLabel)
        
        
        bottomBar.rframe(x: 0, y: 623, width: 375, height: 44)
        sendButton.addTarget(self, action: #selector(sendButtonAction), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ReplyVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ReplyVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    func leftButtonAction(){
        dismiss(animated: false, completion: nil)
       
    }
    
    func likeButtonAction(){
        
        apiManager2.setApi(path: "/contents/like", method: .post, parameters: ["content_id":ReplyVC.receivedContentId,"is_like":likeFlag], header: ["authorization":users.string(forKey: "token")!])
        
        if likeFlag == 0{
            apiManager2.requestLike(completion: { (result) in
                self.likeButton.setImage(UIImage(named: "likeFill"), for: UIControlState.normal)
                self.likeFlag = 1
                self.likeLabel.text = "좋아요 \(ReplyVC.receivedLikeCount+1)개"
            })

        }else{
            apiManager2.requestLike(completion: { (result) in
                self.likeButton.setImage(UIImage(named: "like"), for: UIControlState.normal)
                self.likeFlag = 0
                self.likeLabel.text = "좋아요 \(ReplyVC.receivedLikeCount-1)개"
            })

        }
        
    }
    
    func sendButtonAction(){
        
        apiManager2.setApi(path: "/contents/\(ReplyVC.receivedContentId)/reply", method: .post, parameters: ["reply": replyTextField.text!], header: ["authorization":users.string(forKey: "token")!])
        apiManager2.requestReply { (result) in
            if result == 0{
                self.replyTextField.endEditing(true)
                self.replyTextField.text = ""
                self.replyContent.removeAll()
                self.loadReply()
                ReplyVC.receivedReplyCount += 1
                self.replyLabel.text = "댓글 \(ReplyVC.receivedReplyCount)개"
                //reply ui reload
            }
        }
        
        
        
        //4. 글쓰면 모델삭제하고????? 다시 로드하고 reload해줌..
        //replyContent.removeAll()
        //loadReply()
        //tableView.reloadData()

    }
    
    func setContents(){
        
        profileImg.image = ReplyVC.receivedProfileImg
        userName.text = ReplyVC.receivedUserName
        writeTime.text = ReplyVC.receivedWriteTime
        content.text = ReplyVC.receivedContent
    }
    
    func setTableView(){
        self.tableView.rframe(x: 0, y: 70, width: 375, height: 553)
        self.tableView.bounces = false
        self.tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func backButtonClicked(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with: UIEvent?) {
        replyTextField.endEditing(true) // textBox는 textFiled 오브젝트 outlet 연동할때의 이름.
        
        self.bottomBar.frame.origin.y = 623.multiplyHeightRatio()
        //항상 일반 한글 키보드 시점으로 맞춰주어 emoji keyboard 끝나고 바깥 부분을 터치해도 문제가 없음.
        self.emojiFlag = 0
    }
    
    // 키보드가 보여지면..
    func keyboardWillShow(notification:NSNotification) {
        
        adjustingHeight(show: false, notification: notification)
    }
    
    // 키보드가 사라지면..
    func keyboardWillHide(notification:NSNotification) {
        
        adjustingHeight(show: true, notification: notification)
        
    }
    
    // 높이를 조정한다 ..
    func adjustingHeight(show:Bool, notification:NSNotification) {
        var userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        let changeInHeight = (keyboardFrame.height) * (show ? 1 : -1)
        
        let changeInEmoji : CGFloat = (42.multiplyHeightRatio()) * (show ? 1 : -1)
        let initialLanguage = bottomBar.textInputMode?.primaryLanguage
        
        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
            
            
            //emoji 키보드 일때
            if self.replyTextField.textInputMode?.primaryLanguage == nil{
                self.bottomBar.frame.origin.y += changeInEmoji
                
                self.emojiFlag = 1
                //print("이모지 일때")
            }
                
                // 이모지다음에 초기 지정 키보드일 때
            else if self.replyTextField.textInputMode?.primaryLanguage == initialLanguage && self.emojiFlag == 1 {
                
                //print("이모지다음에 처음으로 돌아가면")
                self.bottomBar.frame.origin.y += (42.multiplyHeightRatio())
                self.emojiFlag = 0
                
            }// 일반 키보드 경우
            else{
                //print("else")
                self.bottomBar.frame.origin.y += changeInHeight
                //self.emojiFlag = 0
            }
        })
        
        
        //범위 밖 충돌 현상 또는 3rd party keyboard 버그 발생시
        if self.bottomBar.frame.origin.y < -258.0 || keyboardFrame.height == 0.0{
            print("충돌현상발생시!!")
            self.bottomBar.frame.origin.y = -216.0
        }
        
        
    }
    
    func drawLine(startX: CGFloat,startY: CGFloat,width: CGFloat, height: CGFloat, border:Bool, color: UIColor, targetView:UIView){
        
        var line: UIView!
        
        if border{
            line = UIView(frame: CGRect(x: startX*widthRatio, y: startY*heightRatio, width: width, height: height*heightRatio))
        }else{
            line = UIView(frame: CGRect(x: startX*widthRatio, y: startY*heightRatio, width: width*widthRatio, height: height))
        }
        line.backgroundColor = UIColor(red: 191/255, green: 196/255, blue: 204/255, alpha: 1.0)//UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 1)
        
        //self.target.addSubview(line)
        targetView.addSubview(line)
    }
    
    
    func changeDate(_ date: String)->String{
        let year = date.substring(to: date.index(date.startIndex, offsetBy: 4))
        let month = date.substring(with: date.index(date.startIndex, offsetBy:5)..<date.index(date.startIndex, offsetBy:7))
        let day = date.substring(with: date.index(date.startIndex, offsetBy:8)..<date.index(date.startIndex, offsetBy:10))
        let date = year+"년 " + "\(Int(month)!)" + "월 " + "\(Int(day)!)" + "일"
        return date
    }
    
    
    
}

// MARK: - extension tableVC

extension ReplyVC{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return replyContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "replyCell", for: indexPath) as! ReplyCell
        
        cell.profileImg.image = UIImage(data: NSData(contentsOf: NSURL(string: (self.replyContent[indexPath.row].profileImg!)) as! URL)! as Data)!
        cell.userName.text = replyContent[indexPath.row].userName
        cell.writeTime.text = changeDate(replyContent[indexPath.row].writeTime!)
        cell.reply.text = replyContent[indexPath.row].reply
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return 100
    }
    
}
