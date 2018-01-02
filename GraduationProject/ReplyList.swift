//
//  ReplyContentList.swift
//  GraduationProject
//
//  Created by 전한경 on 2017. 5. 4..
//  Copyright © 2017년 윤민섭. All rights reserved.
//


import Foundation

class ReplyList: NSObject{
      
    public var profileImg : String?
    public var userName : String?
    public var reply : String?
    public var writeTime : String?
    public var userId : Int?
    public var replyId : Int?
    public var contentId : Int?
    
    init(profileImg: String?, userName: String?, reply: String?, writeTime: String?, userId: Int?, replyId: Int?, contentId: Int?) {
        self.profileImg = profileImg
        self.userName = userName
        self.reply = reply
        self.writeTime = writeTime
        self.userId = userId
        self.replyId = replyId
        self.contentId = contentId
    }
}
