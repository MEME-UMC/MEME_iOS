//
//  PortfolioCategories.swift
//  MEME
//
//  Created by 황채웅 on 2/15/24.
//

import Foundation
enum PortfolioCategories: String, Codable, CaseIterable {
    case DAILY
    case INTERVIEW
    case ACTOR
    case PARTY
    case WEDDING
    case PROSTHETIC
    case STUDIO
    case ETC
    
    var korName: String {
        switch self {
        case .DAILY:
            return "데일리 메이크업"
        case .INTERVIEW:
            return "배우 메이크업"
        case .ACTOR:
            return "면접 메이크업"
        case .PARTY:
            return "파티/이벤트 메이크업"
        case .WEDDING:
            return "웨딩 메이크업"
        case .PROSTHETIC:
            return "특수 메이크업"
        case .STUDIO:
            return "스튜디오 메이크업"
        case .ETC:
            return "기타(속눈썹, 퍼스널컬러)"
        }
    }
}

