//
//  Region.swift
//  MEME
//
//  Created by 이동현 on 2/15/24.
//

import Foundation

enum Region: String, CaseIterable {
    case JONGNO
    case JUNG
    case YONGSAN
    case SEONGDONG
    case GWANGJIN
    case DONGDAEMUN
    case JUNGNANG
    case SEONGBUK
    case GANGBUK
    case DOBONG
    case NOWON
    case EUNPYEONG
    case SEODAEMUN
    case MAPO
    case YANGCHEON
    case GANGSEO
    case GURO
    case GEUMCHEON
    case YEONGDEUNGPO
    case DONGJAK
    case GWANAK
    case SEOCHO
    case GANGNAM
    case SONGPA
    case GANGDONG
    
    var koreanName: String {
        switch self {
        case .JONGNO: return "종로구"
        case .JUNG: return "중구"
        case .YONGSAN: return "용산구"
        case .SEONGDONG: return "성동구"
        case .GWANGJIN: return "광진구"
        case .DONGDAEMUN: return "동대문구"
        case .JUNGNANG: return "중랑구"
        case .SEONGBUK: return "성북구"
        case .GANGBUK: return "강북구"
        case .DOBONG: return "도봉구"
        case .NOWON: return "노원구"
        case .EUNPYEONG: return "은평구"
        case .SEODAEMUN: return "서대문구"
        case .MAPO: return "마포구"
        case .YANGCHEON: return "양천구"
        case .GANGSEO: return "강서구"
        case .GURO: return "구로구"
        case .GEUMCHEON: return "금천구"
        case .YEONGDEUNGPO: return "영등포구"
        case .DONGJAK: return "동작구"
        case .GWANAK: return "관악구"
        case .SEOCHO: return "서초구"
        case .GANGNAM: return "강남구"
        case .SONGPA: return "송파구"
        case .GANGDONG: return "강동구"
        }
    }
}
