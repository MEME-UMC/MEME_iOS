//
//  SkinType.swift
//  MEME
//
//  Created by 이동현 on 2/15/24.
//

import Foundation

enum SkinType: String, CaseIterable {
    case DRY, COMMON, OILY, COMBINATIONAL, UNKNOWN
    
    var korString: String {
        switch self {
        case .DRY:
            return "건성"
        case .COMMON:
            return "중성"
        case .OILY:
            return "지성"
        case .COMBINATIONAL:
            return "복합성"
        case .UNKNOWN:
            return "모르겠음"
        }
    }
}
