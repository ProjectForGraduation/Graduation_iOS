//
//  ContentList.swift
//  GraduationProject
//
//  Created by 윤민섭 on 2017. 4. 12..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import Foundation


class MyContentList: NSObject{
    
    public var contentId : Int?
    public var userId : Int?
    public var userName : String?
    public var profileImg : String?
    public var contentText : String?
    public var contentImage : String?
    public var createdAt : String?
    public var updatedAt : String?
    public var share_range: Int?
    public var location_range: Int?
    public var isLiked : Int?
    public var likeCount : Int?
    
    init(contentId: Int?, userId: Int?, userName: String?, profileImg: String?, contentText: String?, contentImage: String?, createdAt: String?, updatedAt: String?, share_range: Int?, location_range: Int?, isLiked: Int?, likeCount: Int?) {
        self.contentId = contentId
        self.userId = userId
        self.userName = userName
        self.profileImg = profileImg
        self.contentText = contentText
        self.contentImage = contentImage
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.share_range = share_range
        self.location_range = location_range
        self.isLiked = isLiked
        self.likeCount = likeCount
    }
    
    
    
    
}

//[{"content_id":13,"user_id":3,"content_text":"first text","hasImage":0,"create_at":"2017-04-10T05:13:16.000Z","update_at":null,"share_range":1,"location_range":1}
//"{
