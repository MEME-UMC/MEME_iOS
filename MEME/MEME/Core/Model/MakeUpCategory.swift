//
//  MakeUpCategory.swift
//  MEME
//
//  Created by 이동현 on 2/15/24.
//

import Foundation

enum MakeUpCategory: String, CaseIterable {
    case DAILY, INTERVIEW, ACTOR, PARTY,
        WEDDING, PROSTHETIC, STUDIO, ETC
    
    var intVal: Int {
        switch self {
        case .DAILY:
            return 0
        case .ACTOR:
            return 1
        case .INTERVIEW:
            return 2
        case .PARTY:
            return 3
        case .WEDDING:
            return 4
        case .PROSTHETIC:
            return 5
        case .STUDIO:
            return 6
        case .ETC:
            return 7
        }
    }
}
