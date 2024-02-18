//
//  DayOfWeek.swift
//  MEME
//
//  Created by 이동현 on 2/5/24.
//

import Foundation

enum DayOfWeek: String, CaseIterable {
    case MON
    case TUE
    case WED
    case THU
    case FRI
    case SAT
    case SUN
    
    var intVal: Int {
        switch self {
        case .MON:
            return 0
        case .TUE:
            return 1
        case .WED:
            return 2
        case .THU:
            return 3
        case .FRI:
            return 4
        case .SAT:
            return 5
        case .SUN:
            return 6
        }
    }
}
