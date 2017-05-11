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
    
    var profileImg = UIImageView()
    var userName = UILabel()
    var writeTime = UILabel()
    var content = UITextView()
    
    var receivedProfileImg = UIImage(named:"gguggu")
    var receivedUserName = "신꾸꾸"
    var receivedWriteTime = "20160731"
    var receivedContent = "안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요"
    
    //
    var emojiFlag : Int = 0
    
    var replyContent: [ReplyList] = [ReplyList(profileImg: "",userName: "한경이",reply: "안녕하세요1",writeTime: "20160726"),ReplyList(profileImg: "",userName: "한경이2",reply: "안녕하세요2",writeTime: "20160727"),ReplyList(profileImg: "",userName: "한경이3",reply: "안녕하세요3",writeTime: "20160728"),ReplyList(profileImg: "",userName: "한경이4",reply: "안녕하세요4",writeTime: "20160728"),ReplyList(profileImg: "",userName: "한경이5",reply: "안녕하세요5",writeTime: "20160728")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBasicView()
        setContents()
        setTableView()
        
    }
    func setBasicView(){
        receivedView.rframe(x: 0, y: 0, width: 375, height: 500)
        
        
        profileImg.rframe(x: 10, y: 10, width: 70, height: 70)
        profileImg.image = UIImage(named: "default")
        profileImg.layer.masksToBounds = false
        profileImg.layer.cornerRadius = 35.multiplyWidthRatio()
        profileImg.clipsToBounds = true
        
        userName.rframe(x: 95, y: 20, width: 50, height: 14)
        userName.setLabel(text: "", align: .left, fontName: "AppleSDGothicNeo-Medium", fontSize: 14, color: UIColor.black)
        
        writeTime.rframe(x: 95, y: 40, width: 70, height: 10)
        writeTime.setLabel(text: "", align: .left, fontName: "AppleSDGothicNeo-Medium", fontSize: 10, color: UIColor.black)
        
        content.rframe(x: 20, y: 100, width: 335, height: 100)
        content.setTextView(fontName: "AppleSDGothicNeo-Medium", size: 12)
        content.textColor = UIColor.black
        content.layer.borderWidth = 1
        content.isUserInteractionEnabled = false
        
        drawLine(startX: 0, startY: 450.multiplyHeightRatio(), width: 375.multiplyWidthRatio(), height: 1, border: false, color: UIColor.blue
,targetView: receivedView)
        
        drawLine(startX: 0, startY: 500.multiplyHeightRatio(), width: 375.multiplyWidthRatio(), height: 1, border: false, color: UIColor.blue
,targetView: receivedView)
        
        receivedView.addSubview(profileImg)
        receivedView.addSubview(userName)
        receivedView.addSubview(writeTime)
        receivedView.addSubview(content)
        
        
        bottomBar.rframe(x: 0, y: 623, width: 375, height: 44)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ReplyVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ReplyVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    func setContents(){
        
        profileImg.image = receivedProfileImg
        userName.text = receivedUserName
        writeTime.text = receivedWriteTime
        content.text = receivedContent
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
        
        //print("height :\(changeInHeight)")
        //print("emojiFlag :\(emojiFlag)")
        //print("밑바닥 :\(self.view.frame.origin.y)")
        
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
        
        cell.profileImg.image = UIImage(named:"default")
        cell.userName.text = replyContent[indexPath.row].userName
        cell.writeTime.text = replyContent[indexPath.row].writeTime
        cell.reply.text = replyContent[indexPath.row].reply
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return 100
    }
    
}
