//
//  File.swift
//  GraduationProject
//
//  Created by 윤민섭 on 2017. 3. 18..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class TimeLineCell: UITableViewCell{
    
    var index = 0;
    
    var profileImg = UIImageView()
    var userName = UIButton()
    var optionBtn = UIButton()
    var contentText = UILabel()
    var contentPic = UIImageView()
    var likeBtn = UIButton()
    var likeCount = UILabel()
    var commentBtn = UIButton()
    var mapBtn = UIButton()
    
    
    var isLiked : Bool = true {
        willSet(newValue){
            if newValue{
                likeBtn.setImage(UIImage(named: "likeFill"), for: .normal)
            }else {
                likeBtn.setImage(UIImage(named: "like"), for: .normal)
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImg.rframe(x: 10, y: 10, width: 30, height: 30)
        //profileImg.image = UIImage(named: "default")
        profileImg.layer.masksToBounds = false
        profileImg.layer.cornerRadius = 15.multiplyWidthRatio()
        profileImg.clipsToBounds = true
        
        userName.rframe(x: 50, y: 18, width: 100, height: 13)
        userName.setButton(title: "", fontName: "AppleSDGothicNeo-SemiBold", fontSize: 15, color: UIColor.black)
        
        optionBtn.rframe(x: 335, y: 22.5, width: 15, height: 5)
        optionBtn.setButton(imageName: "option", target: self, action: #selector(optionBtnAction))
        
        contentText.rframe(x: 10, y: 60, width: 355, height: 0)
        contentText.setLabel(text: "", align: .left, fontName: "AppleSDGothicNeo-Medium", fontSize: 17, color: UIColor.black)
        
        
        contentPic.rframe(x: 0, y: (contentText.y+contentText.height+10.multiplyHeightRatio()).remultiplyHeightRatio(), width: 375, height: 375)
        //contentPic.image = UIImage(named: "gguggu")
        
        likeBtn.rframe(x: 10, y: (contentPic.y+contentPic.height+10.multiplyHeightRatio()).remultiplyHeightRatio(), width: 30, height: 30)
        likeBtn.setButton(imageName: "like", target: self, action: #selector(likeBtnAction))
        
        likeCount.rframe(x: 45, y: (contentPic.y+contentPic.height+20.multiplyHeightRatio()).remultiplyHeightRatio(), width: 100, height: 0)
        //likeCount.setLabel(text: "좋아요 99개", align: .left, fontName: "AppleSDGothicNeo-Medium", fontSize: 10, color: UIColor.black)
        likeCount.sizeToFit()
        
        mapBtn.rframe(x: 300, y: (contentPic.y+contentPic.height+14.multiplyHeightRatio()).remultiplyHeightRatio(), width: 30, height: 25)
        mapBtn.setButton(imageName: "marker", target: self, action: #selector(mapBtnAction))
        
        commentBtn.rframe(x: 335, y: (contentPic.y+contentPic.height+10.multiplyHeightRatio()).remultiplyHeightRatio(), width: 30, height: 30)
        commentBtn.setButton(imageName: "comment", target: self, action: #selector(commentBtnAction))
        
        contentView.addSubview(profileImg)
        contentView.addSubview(userName)
        contentView.addSubview(optionBtn)
        contentView.addSubview(contentText)
        contentView.addSubview(contentPic)
        contentView.addSubview(likeBtn)
        contentView.addSubview(likeCount)
        contentView.addSubview(mapBtn)
        contentView.addSubview(commentBtn)
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func anotherBtnUp(){
        mapBtn.frame.origin.y = contentText.y + contentText.height + 14.multiplyHeightRatio()
        likeBtn.frame.origin.y = contentText.y + contentText.height + 10.multiplyHeightRatio()
        likeCount.frame.origin.y = contentText.y + contentText.height + 20.multiplyHeightRatio()
        commentBtn.frame.origin.y = contentText.y + contentText.height + 10.multiplyHeightRatio()
    }
    
    func userBtnAction(){

    }
    
    // MARK: - button action
    
    func likeBtnAction(){
        // 이곳에서 서버로 내가 눌렀는지 안눌렀는지 보낸다.
        if isLiked{
            isLiked = false
        }else{
            isLiked = true
        }
    }
    
    func mapBtnAction(){
       TimeLineTableVC.index = self.index
    }
    
    func commentBtnAction(){
        
    }
 
    
    func optionBtnAction(){
        
    }
    
    
    
}
