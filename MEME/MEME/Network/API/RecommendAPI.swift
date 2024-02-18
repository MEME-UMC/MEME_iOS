//
//  RecommendAPI.swift
//  MEME
//
//  Created by 정민지 on 2/14/24.
//

import Foundation
import Moya

enum RecommendAPI {
    case getRecommendArtistByReview
    case getRecommendArtistByRecent
}

extension RecommendAPI: MemeAPI {
    var domain: MemeDomain {
        return .recommend
    }
    
    var urlPath: String {
        switch self {
        case .getRecommendArtistByReview:
            return "/review"
        case .getRecommendArtistByRecent:
            return "/recent"
        }
    }
    
    var error: [Int : NetworkError]? {
        return .none
    }
    
    var headerType: HTTPHeaderFields {
        switch self {
        case .getRecommendArtistByReview, .getRecommendArtistByRecent:
            return .hasAccessToken
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getRecommendArtistByReview, .getRecommendArtistByRecent:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getRecommendArtistByReview:
            return .requestPlain
        case .getRecommendArtistByRecent:
            return .requestPlain
        }
    }
}
