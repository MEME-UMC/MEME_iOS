//
//  WorkExperience.swift
//  MEME
//
//  Created by 이동현 on 2/15/24.
//

import Foundation

enum WorkExperience: String, CaseIterable {
    case ZERO
    case ONE
    case TWO
    case THREE
    case FOUR
    case FIVE
    case SIX
    case SEVEN
    case EIGHT
    case NINE
    case TEN
    
    var description: String {
        switch self {
        case .ZERO:
            "1년 미만"
        case .ONE:
            "1년 이상"
        case .TWO:
            "2년 이상"
        case .THREE:
            "3년 이상"
        case .FOUR:
            "4년 이상"
        case .FIVE:
            "5년 이상"
        case .SIX:
            "6년 이상"
        case .SEVEN:
            "7년 이상"
        case .EIGHT:
            "8년 이상"
        case .NINE:
            "9년 이상"
        case .TEN:
            "10년 이상"
        }
    }
}
