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
                    meta(resp["meta"]["code"].intValue,resp["token"].stringValue)
                    
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    func requestContents(completion : @escaping ([ContentList])->Void){
        
        Alamofire.request(url,method: method,parameters: parameters,encoding: encode, headers: header).responseJSON{ response in
            switch(response.result) {
                
            case .success(_):
                if let json = response.result.value{
                    let resp = JSON(json)
                    var contentList = [ContentList]()
                    for idx in 0..<resp.count{
                        let content = ContentList(contentId: resp[idx]["content_id"].intValue, userId: resp[idx]["user_id"].intValue,userName: resp[idx]["user_name"].stringValue, contentText: resp[idx]["content_text"].stringValue, contentImage: "http://"+resp[idx]["image_dir"].stringValue, createdAt: resp[idx]["create_at"].stringValue,updatedAt: resp[idx]["update_at"].stringValue ,share_range: resp[idx]["share_range"].intValue, location_range: resp[idx]["location_range"].intValue)
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
