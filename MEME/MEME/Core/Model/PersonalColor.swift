//
//  PersonalColor.swift
//  MEME
//
//  Created by 이동현 on 2/15/24.
//

import Foundation

enum PersonalColor: String, CaseIterable {
    case SPRING, SUMMER, AUTUMN, WINTER, UNKNOWN
    
    var korString: String {
        switch self {
        case .SPRING:
            "봄웜톤"
        case .SUMMER:
            "여름쿨톤"
        case .AUTUMN:
            "가을웜톤"
        case .WINTER:
            "겨울쿨톤"
        case .UNKNOWN:
            "모르겠음"
        }
    }
}
