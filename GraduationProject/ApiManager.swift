//
//  ApiManager.swift
//  GraduationProject
//
//  Created by 윤민섭 on 2017. 3. 17..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import SwiftyJSON
import Alamofire

private let server = "http://13.124.115.238:8080"

class ApiManager {
    
    private var url: String!
    private var method: HTTPMethod!
    private var parameters: Parameters!
    private var header: HTTPHeaders!
    private let encode = URLEncoding.default
    
    
    public func setApi(path: String, method: HTTPMethod, parameters: Parameters,header: HTTPHeaders){
        self.url = server + path
        self.method = method
        self.parameters = parameters
        self.header = header
    }
    
    func requestRegisterUser(completion: @escaping(Int)->Void){
        
        Alamofire.request(url,method: method, parameters: parameters, encoding: encode, headers: header).responseJSON { (response) in
            switch(response.result){
            case .success(_):
                if let json = response.result.value{
                    let resp = JSON(json)
                    print(resp)
                    completion(resp["meta"]["code"].intValue)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    func requestLogin(meta: @escaping(Int,String)->Void){
        
        Alamofire.request(url,method: method, parameters: parameters, encoding: encode, headers: header).responseJSON { (response) in
            switch(response.result){
            case .success(_):
                if let json = response.result.value{
                    let resp = JSON(json)
                    print(resp)
                    meta(resp["meta"]["code"].intValue,resp["token"].stringValue)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    func requestAroundContents(completion : @escaping ([AroundContentList])->Void){
        
        Alamofire.request(url,method: method,parameters: parameters,encoding: encode, headers: header).responseJSON{ response in
            switch(response.result) {
                
            case .success(_):
                if let json = response.result.value{
                    let resp = JSON(json)
                    print(resp)
                    var contentList = [AroundContentList]()
                    for idx in 0..<resp["data"].count{
                        let content = AroundContentList(contentId: resp["data"][idx]["content_id"].intValue, userId: resp["data"][idx]["user_id"].intValue,userName: resp["data"][idx]["user_name"].stringValue, profileImg: resp["data"][idx]["profile_dir"].stringValue, contentText: resp["data"][idx]["content_text"].stringValue, contentImage: resp["data"][idx]["image_dir"].stringValue,createdAt: resp["data"][idx]["create_at"].stringValue ,updatedAt: resp["data"][idx]["update_at"].stringValue, share_range: resp["data"][idx]["share_range"].intValue, location_range: resp["data"][idx]["location_range"].intValue , isLiked: resp["data"][idx]["is_like"].intValue, likeCount: resp["data"][idx]["like_cnt"].intValue)
                        contentList += [content]
                    }
                    completion(contentList)
                }
                break
            case .failure(_):

                break
                
            }
        }
    }
    
    func requestMyContents(completion : @escaping ([MyContentList])->Void){
        print(url)
        Alamofire.request(url,method: method,parameters: parameters,encoding: encode, headers: header).responseJSON{ response in
            switch(response.result) {
                
            case .success(_):
                if let json = response.result.value{
                    let resp = JSON(json)
                    print(resp)
                    var contentList = [MyContentList]()
                    for idx in 0..<resp["myContents"].count{
                        let content = MyContentList(contentId: resp["myContents"][idx]["content_id"].intValue, userId: resp["myContents"][idx]["user_id"].intValue,userName: resp["myContents"][idx]["user_name"].stringValue, profileImg: resp["myContents"][idx]["profile_dir"].stringValue, contentText: resp["myContents"][idx]["content_text"].stringValue, contentImage: resp["myContents"][idx]["image_dir"].stringValue,createdAt: resp["myContents"][idx]["create_at"].stringValue ,updatedAt: resp["myContents"][idx]["update_at"].stringValue, share_range: resp["myContents"][idx]["share_range"].intValue, location_range: resp["myContents"][idx]["location_range"].intValue , isLiked: resp["myContents"][idx]["is_like"].intValue, likeCount: resp["myContents"][idx]["like_cnt"].intValue)
                        contentList += [content]
                    }
                    completion(contentList)
                }
                break
            case .failure(_):
                print("fail")
                break
            }
        }
    }
    
    func requestUserInfo(completion: @escaping (UserInfo)->Void){
        Alamofire.request(url,method: method, parameters: parameters, encoding: encode, headers: header).responseJSON { (response) in
            switch(response.result){
            case .success(_):
                if let json = response.result.value{
                    let resp = JSON(json)
                    print(resp)
                    let userInfo = UserInfo(login_id: resp["data"][0]["login_id"].stringValue, profile_dir: resp["data"][0]["profile_dir"].stringValue, user_name: resp["data"][0]["user_name"].stringValue,user_id: resp["data"][0]["user_id"].intValue)
                    completion(userInfo)
                }
                break
            case .failure(_):
                print("fail")
                break
            }
        }

    }
    
    func requestUpdatePosition(){
        Alamofire.request(url,method: method, parameters: parameters, encoding: encode, headers: header).responseJSON { (response) in
            switch(response.result){
            case .success(_):
                if let json = response.result.value{
                    let resp = JSON(json)
                }

                break
            case .failure(_):
                break
            }
        }
    }
    
    func requestDeleteContents(completion: @escaping (Int)->Void){
        Alamofire.request(url,method: method, parameters: parameters, encoding: encode, headers: header).responseJSON { (response) in
            switch(response.result){
            case .success(_):
                if let json = response.result.value{
                    let resp = JSON(json)
                    print(resp)
                    completion(resp["meta"]["code"].intValue)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    func requestToken(completion : @escaping (String) -> Void){
        Alamofire.request(url,method: method, parameters: parameters, encoding: encode, headers: header).responseJSON { (response) in
            switch(response.result){
            case .success(_):
                if let json = response.result.value{
                    let resp = JSON(json)
                    if resp["meta"]["code"].intValue == 0 && resp["token"].stringValue != ""{
                        completion(resp["token"].stringValue)
                    }else{
                        completion("OPEN_LOGINVC")
                    }
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    func requestChangeProfileImage(_ imageData: Data){
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData, withName: "userprofile",fileName: "default.jpeg", mimeType: "image/jpeg")
        },
            to: url,
            headers:header,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        switch(response.result){
                        case .success(_):
                            if let json = response.result.value{
                                let resp = JSON(json)
                                print(resp)
                            }
                            break
                        case .failure(_):
                            print("error")
                            break
                        }
                    }
                case .failure(_):
                    break
                }
            }
        )
    }
    
    func requestLike(completion : @escaping (Int)->Void){
        Alamofire.request(url,method: method,parameters: parameters,encoding: encode, headers: header).responseJSON{ response in
            switch(response.result) {
                
            case .success(_):
                if let json = response.result.value{
                    let resp = JSON(json)
                    print(resp)
                    completion(resp["meta"]["code"].intValue)
                }
                break
            case .failure(_):
                break
                
            }
        }
    }
    func requestUpload(completion : @escaping (String)->Void){
        
        
        Alamofire.request(url,method: method,parameters: parameters,encoding: encode, headers: header).responseJSON{ response in
            print("faffa")
            print(response.result.value!)
            switch(response.result) {
                
            case .success(_):
                if let json = response.result.value{
                    let resp = JSON(json)
                    //print("aa")
                    //print(resp)
                    
                    completion(resp.description)
                }
                break
            case .failure(_):
                
                break
                
            }
        }
//        Alamofire.request(url,method: method,parameters: parameters,encoding: encode, headers: header).responseString { response in
//            
//            print(response.result.value!)
//            
//        }

        
        
    }
    
    
}
