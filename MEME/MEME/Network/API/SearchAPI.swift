//
//  SearchAPI.swift
//  MEME
//
//  Created by 정민지 on 2/13/24.
//

import Foundation
import Moya

enum SearchAPI {
    case getSearchArtist(
        artistId: Int,
        page: Int?,
        sort: SearchSort?
    )
    case getSearchCategory(
        category: SearchCategory,
        page: Int?,
        sort: SearchSort?
    )
    case getSearchAll(
        page: Int?,
        sort: SearchSort?
    )
    case getSearchText(
        query: String,
        page: Int?,
        sort: SearchSort?
    )
}

extension SearchAPI: MemeAPI {
    var domain: MemeDomain {
        return .search
    }
    
    var urlPath: String {
        switch self {
        case .getSearchArtist:
            return "/artist"
        case .getSearchCategory:
            return "/category"
        case .getSearchAll:
            return "/all"
        case .getSearchText:
            return ""
        }
    }
    
    var error: [Int : NetworkError]? {
        return .none
    }
    
    var headerType: HTTPHeaderFields {
        switch self {
        case .getSearchArtist, .getSearchCategory, .getSearchAll, .getSearchText:
            return .hasAccessToken
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getSearchArtist, .getSearchCategory, .getSearchAll, .getSearchText:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getSearchArtist(
            artistId: let artistId,
            page: let page,
            sort: let sort):
            var parameters: [String: Any] = ["artistId": artistId]
            if let page = page {
                parameters["page"] = page
            }
            if let sort = sort {
                parameters["sort"] = sort.rawValue
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .getSearchCategory(
            category: let category,
            page: let page,
            sort: let sort):
            var parameters: [String: Any] = ["category": category]
            if let page = page {
                parameters["page"] = page
            }
            if let sort = sort {
                parameters["sort"] = sort.rawValue
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .getSearchAll(let page, let sort):
            return .requestParameters(parameters: ["page": page ?? 0, "sort": sort ?? .review], encoding: URLEncoding.queryString)
        case .getSearchText(
            query: let query,
            page: let page,
            sort: let sort):
            var parameters: [String: Any] = ["query": query]
            if let page = page {
                parameters["page"] = page
            }
            if let sort = sort {
                parameters["sort"] = sort.rawValue
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
}
