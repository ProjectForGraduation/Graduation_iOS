//
//  UserInfo.swift
//  GraduationProject
//
//  Created by 윤민섭 on 2017. 5. 3..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import Foundation

class UserInfo : NSObject{
    public var login_id : String?
    public var profile_dir : String?
    public var user_name : String?
    init(login_id: String?, profile_dir: String?, user_name: String?) {
        self.login_id = login_id
        self.profile_dir = profile_dir
        self.user_name = user_name
    }
    
}
