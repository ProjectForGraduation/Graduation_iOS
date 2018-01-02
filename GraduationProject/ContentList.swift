//
//  ContentList.swift
//  GraduationProject
//
//  Created by 윤민섭 on 2017. 4. 12..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import Foundation


class ContentList: NSObject{
    
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
    public var lng : Double?
    public var lat : Double?
    public var replyCount : Int?
    public var login_id : String?

    init(contentId: Int?, userId: Int?, userName: String?, profileImg: String?, contentText: String?, contentImage: String?, createdAt: String?, updatedAt: String?, share_range: Int?, location_range: Int?, isLiked: Int?, likeCount: Int?, lng: Double?, lat: Double?, replyCount: Int?, login_id: String?) {
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
        self.lng = lng
        self.lat = lat
        self.replyCount = replyCount
        self.login_id = login_id
    }
}
