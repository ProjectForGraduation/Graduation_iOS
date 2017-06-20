//
//  ConvenienceMethod.swift
//  GraduationProject
//
//  Created by 윤민섭 on 2017. 6. 20..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import Foundation

func changeDate(_ date: String)->String{
    let year = date.substring(to: date.index(date.startIndex, offsetBy: 4))
    let month = date.substring(with: date.index(date.startIndex, offsetBy:5)..<date.index(date.startIndex, offsetBy:7))
    let day = date.substring(with: date.index(date.startIndex, offsetBy:8)..<date.index(date.startIndex, offsetBy:10))
    let date = year+"년 " + "\(Int(month)!)" + "월 " + "\(Int(day)!)" + "일"
    return date
}
    
