//
//  MyListCell.swift
//  GraduationProject
//
//  Created by 윤민섭 on 2017. 3. 18..
//  Copyright © 2017년 윤민섭. All rights reserved.
//
import UIKit

class UserListCell: UITableViewCell{
    
    var mainProfileImg = UIImageView()
    var userId = UILabel()
    var userName = UILabel()
    var requestBtn = UIButton()
    var mylistProfileImg = UIImageView()
    var mylistName = UILabel()
    var createdDate = UILabel()
    var optionBtn = UIButton()
    var contentText = UILabel()
    var contentPic = UIImageView()
    var likeBtn = UIButton()
    var likeCount = UILabel()
    var commentBtn = UIButton()
    var mapBtn = UIButton()
    
    
    let apiManager = ApiManager()
    let users = UserDefaults.standard
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainProfileImg.rcenter(y: 10, width: 100, height: 100, targetWidth: 375)
        mainProfileImg.image = UIImage(named: "default")
        mainProfileImg.layer.masksToBounds = false
        mainProfileImg.layer.cornerRadius = 50.multiplyWidthRatio()
        mainProfileImg.clipsToBounds = true
        
        userId.rcenter(y: 120, width: 375, height: 14, targetWidth: 375)
        userId.setLabel(text: "yoonmssssss", align: .center, fontName: "AppleSDGothicNeo-Medium", fontSize: 15, color: UIColor.black)
        
        userName.rcenter(y: 136, width: 375, height: 12, targetWidth: 375)
        userName.setLabel(text: "윤민섭", align: .center, fontName: "AppleSDGothicNeo-Medium", fontSize: 13, color: UIColor.black)
        
        requestBtn.rcenter(y: 160, width: 30, height: 30, targetWidth: 375)
        requestBtn.setImage(UIImage(named: "add-contact"), for: .normal)
        requestBtn.addAction(target: self, action: #selector(requestFriend))
        //친구 아니면 까만색 친구 신청했으면 빨간색 친구 됐으면 파란색 아마되겠지?
        
        mylistProfileImg.rframe(x: 10, y: 10, width: 30, height: 30)
        mylistProfileImg.image = UIImage(named: "default")
        mylistProfileImg.layer.masksToBounds = false
        mylistProfileImg.layer.cornerRadius = 15.multiplyWidthRatio()
        mylistProfileImg.clipsToBounds = true
        
        mylistName.rframe(x: 50, y: 14, width: 100, height: 11)
        mylistName.setLabel(text: "", align: .left, fontName: "AppleSDGothicNeo-Medium", fontSize: 11, color: UIColor.black)
    
        
        createdDate.rframe(x: 50, y: 26, width: 100, height: 11)
        createdDate.setLabel(text: "", align: .left, fontName: "AppleSDGothicNeo-Medium", fontSize: 11, color: UIColor.black)
        
        optionBtn.rframe(x: 335, y: 22.5, width: 15, height: 5)
        optionBtn.setButton(imageName: "option", target: self, action: #selector(optionBtnActions))
        
        contentText.rframe(x: 10, y: 50, width: 355, height: 0)
        contentText.setLabel(text: "", align: .left, fontName: "AppleSDGothicNeo-Medium", fontSize: 11, color: UIColor.black)
        contentText.sizeToFit()
        
        contentPic.rframe(x: 0, y: (contentText.y+contentText.height+10.multiplyHeightRatio()).remultiplyHeightRatio(), width: 375, height: 375)
        
        likeBtn.rframe(x: 10, y: (contentPic.y+contentPic.height+10.multiplyHeightRatio()).remultiplyHeightRatio(), width: 30, height: 30)
        likeBtn.setButton(imageName: "like", target: self, action: #selector(likeBtnActions))
        
        likeCount.rframe(x: 45, y: (contentPic.y+contentPic.height+20.multiplyHeightRatio()).remultiplyHeightRatio(), width: 100, height: 0)
        likeCount.setLabel(text: "좋아요 99개", align: .left, fontName: "AppleSDGothicNeo-Medium", fontSize: 10, color: UIColor.black)
        likeCount.sizeToFit()
        
        mapBtn.rframe(x: 300, y: (contentPic.y+contentPic.height+10.multiplyHeightRatio()).remultiplyHeightRatio(), width: 30, height: 30)
        mapBtn.setButton(imageName: "marker", target: self, action: #selector(mapBtnActions))
        
        commentBtn.rframe(x: 335, y: (contentPic.y+contentPic.height+10.multiplyHeightRatio()).remultiplyHeightRatio(), width: 30, height: 30)
        commentBtn.setButton(imageName: "comment", target: self, action: #selector(commentBtnActions))
        
        
        contentView.addSubview(mainProfileImg)
        contentView.addSubview(userId)
        contentView.addSubview(userName)
        contentView.addSubview(requestBtn)
        contentView.addSubview(mylistProfileImg)
        contentView.addSubview(mylistName)
        contentView.addSubview(createdDate)
        contentView.addSubview(optionBtn)
        contentView.addSubview(contentText)
        contentView.addSubview(contentPic)
        contentView.addSubview(likeBtn)
        contentView.addSubview(likeCount)
        contentView.addSubview(mapBtn)
        contentView.addSubview(commentBtn)
    }
    
    func likeBtnActions(){
        
    }
    
    func mapBtnActions(){
        
    }
    
    func commentBtnActions(){
        
    }
    
    func optionBtnActions(){
        
    }
    
    func requestFriend(){
        print("1")
        self.requestBtn.tintColor = UIColor.red
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func profileHidden(_ isindexOne: Bool){
        mainProfileImg.isHidden = isindexOne
        userId.isHidden = isindexOne
        userName.isHidden = isindexOne
        requestBtn.isHidden = isindexOne
        mylistProfileImg.isHidden = !isindexOne
        mylistName.isHidden = !isindexOne
        createdDate.isHidden = !isindexOne
        optionBtn.isHidden = !isindexOne
        contentText.isHidden = !isindexOne
        contentPic.isHidden = !isindexOne
        likeBtn.isHidden = !isindexOne
        likeCount.isHidden = !isindexOne
        mapBtn.isHidden = !isindexOne
        commentBtn.isHidden = !isindexOne
    }
    
    func anotherBtnUp(){
        mapBtn.frame.origin.y = contentText.y + contentText.height + 10.multiplyHeightRatio()
        likeBtn.frame.origin.y = contentText.y + contentText.height + 10.multiplyHeightRatio()
        likeCount.frame.origin.y = contentText.y + contentText.height + 20.multiplyHeightRatio()
        commentBtn.frame.origin.y = contentText.y + contentText.height + 10.multiplyHeightRatio()
    }
    
    func anotherBtnDown(){
        mapBtn.frame.origin.y = contentPic.y + contentPic.height + 10.multiplyHeightRatio()
        likeBtn.frame.origin.y = contentPic.y + contentPic.height + 10.multiplyHeightRatio()
        likeCount.frame.origin.y = contentPic.y + contentPic.height + 20.multiplyHeightRatio()
        commentBtn.frame.origin.y = contentPic.y + contentPic.height + 10.multiplyHeightRatio()
    }
}
