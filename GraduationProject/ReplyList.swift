//
//  ReplyList.swift
//  GraduationProject
//
//  Created by 전한경 on 2017. 5. 3..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import Foundation

class ReplyList: NSObject{
    
    public var profileImg : String?
    public var userName : String?
    public var reply : String?
    public var writeTime : String?
    
    
    init(profileImg: String?, userName: String?, reply: String?, writeTime: String?) {
        self.profileImg = profileImg
        self.userName = userName
        self.reply = reply
        self.writeTime = writeTime
    }
    
    
    
    
    
}
