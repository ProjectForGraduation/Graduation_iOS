//
//  ReplyContentCell.swift
//  GraduationProject
//
//  Created by 전한경 on 2017. 5. 3..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class ReplyCell: UITableViewCell {
    
    var profileImg = UIImageView()
    var userName = UILabel()
    var reply = UILabel()
    var writeTime = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImg.rframe(x: 10, y: 10, width: 30, height: 30)
        profileImg.image = UIImage(named: "default")
        profileImg.layer.masksToBounds = false
        profileImg.layer.cornerRadius = 15.multiplyWidthRatio()
        profileImg.clipsToBounds = true
        
        userName.rframe(x: 55, y: 20, width: 50, height: 14)
        userName.setLabel(text: "", align: .left, fontName: "AppleSDGothicNeo-Medium", fontSize: 14, color: UIColor.black)
        
        writeTime.rframe(x: 290, y: 20, width: 70, height: 10)
        writeTime.setLabel(text: "", align: .left, fontName: "AppleSDGothicNeo-Medium", fontSize: 10, color: UIColor.black)
        
        reply.rframe(x: 20, y: 50, width: 335, height: 12)
        reply.setLabel(text: "", align: .left, fontName: "AppleSDGothicNeo-Medium", fontSize: 12, color: UIColor.black)
        
        
        contentView.addSubview(profileImg)
        contentView.addSubview(userName)
        contentView.addSubview(reply)
        contentView.addSubview(writeTime)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
