//
//  ReceivedFriendList.swift
//  GraduationProject
//
//  Created by 윤민섭 on 2017. 5. 21..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import Foundation

class ReceivedFriendList{
    
    var req_user_id: Int?
    var user_name: String?
    var profile_dir: String?
    
    init(req_user_id: Int?, user_name: String?, profile_dir: String?) {
        self.req_user_id = req_user_id
        self.user_name = user_name
        self.profile_dir = profile_dir
    }
    
}
