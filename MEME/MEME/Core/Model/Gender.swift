//
//  Gender.swift
//  MEME
//
//  Created by 이동현 on 2/15/24.
//

import Foundation


enum Gender: String, CaseIterable {
    case MALE
    case FEMALE
    
    var korString: String {
        switch self {
        case .MALE:
            "남성"
        case .FEMALE:
            "여성"
        }
    }

}
