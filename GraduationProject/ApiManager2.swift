//
//  ApiManagerHK.swift
//  GraduationProject
//
//  Created by 전한경 on 2017. 5. 4..
//  Copyright © 2017년 윤민섭. All rights reserved.
//


import SwiftyJSON
import Alamofire

private let server = "http://13.124.115.238:8080"

class ApiManager2 {
    
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
    
    
    func requestWrite(imageData:Data, text:String, share:Int, location:Int, hasImage:Int, lng:Double, lat:Double, completion : @escaping (Int)->Void){
        
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                multipartFormData.append(text.data(using: .utf8)!, withName: "content_text")
                multipartFormData.append(share.description.data(using: .utf8)!, withName: "share_range")
                multipartFormData.append(location.description.data(using: .utf8)!, withName: "location_range")
                multipartFormData.append(hasImage.description.data(using: .utf8)!, withName: "has_image")
                multipartFormData.append(imageData, withName: "content_image",fileName: "default.jpeg", mimeType: "image/jpeg")
                
                multipartFormData.append(lng.description.data(using: .utf8)!, withName: "lng")
                multipartFormData.append(lat.description.data(using: .utf8)!, withName: "lat")
                
                
        },
            to: url,
            headers:header,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        
                        if let json = response.result.value{
                            let resp = JSON(json)
                            
                            completion(resp["meta"]["code"].intValue)
                        }
                        
                        
                    }
                case .failure(_):
                    
                    completion(-55)
                }
        }
        )
        
        
        
    }
   
    func getReply(completion : @escaping ([AroundContentList])->Void){
        
        Alamofire.request(url,method: method,parameters: parameters,encoding: encode, headers: header).responseJSON{ response in
            switch(response.result) {
                
            case .success(_):
                if let json = response.result.value{
                    let resp = JSON(json)
                    print(resp)
//                    var contentList = [AroundContentList]()
//                    for idx in 0..<resp["data"].count{
//                        let content = AroundContentList(contentId: resp["data"][idx]["content_id"].intValue, userId: resp["data"][idx]["user_id"].intValue,userName: resp["data"][idx]["user_name"].stringValue, profileImg: resp["data"][idx]["profile_dir"].stringValue, contentText: resp["data"][idx]["content_text"].stringValue, contentImage: resp["data"][idx]["image_dir"].stringValue,createdAt: resp["data"][idx]["create_at"].stringValue ,updatedAt: resp["data"][idx]["update_at"].stringValue, share_range: resp["data"][idx]["share_range"].intValue, location_range: resp["data"][idx]["location_range"].intValue , isLiked: resp["data"][idx]["is_like"].intValue, likeCount: resp["data"][idx]["like_cnt"].intValue)
//                        contentList += [content]
//                    }
//                    completion(contentList)
                }
                break
            case .failure(_):
                
                break
                
            }
        }
    }

    func requestReply(){
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
    
    func requestLike(select:Int){
    
    }
    
    
    
    
    
    
    
}

