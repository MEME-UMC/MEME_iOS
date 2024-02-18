//
//  MyPageAPI.swift
//  MEME
//
//  Created by 정민지 on 2/13/24.
//

import Foundation
import Moya

enum MyPageAPI {
    case getMyPage(userId: Int)
    case patchProfile(
        modelId: Int,
        profileImg: String,
        nickName: String,
        gender: Gender,
        skinType: SkinType,
        personalColor: PersonalColor
    )
    case getFavoriteArtist(modelId: Int, page: Int?)
    case getFavoritePortfolio(
        modelId: Int,
        portfolioId: Int
    )
    case postFavoriteArtist(
        modelId: Int,
        artistId: Int
    )
    case postFavoritePortfolio(
        modelId: Int,
        portfolioId: Int
    )
    case deleteFavoriteArtist(
        modelId: Int,
        artistId: Int
    )
    case deleteFavoritePortfolio(
        modelId: Int,
        portfolioId: Int
    )
}

extension MyPageAPI: MemeAPI {
    var domain: MemeDomain {
        return .mypage
    }
    
    var urlPath: String {
        switch self {
        case .getMyPage(userId: let id):
            return "/profile/\(id)"
        case .patchProfile:
            return "/profile/model"
        case .getFavoriteArtist(modelId: let id, _):
            return "/\(id)/favorite/artist"
        case .getFavoritePortfolio(modelId: let id, _):
            return "/\(id)/favorite/portfolio"
        case .postFavoriteArtist:
            return "/favorite/artist"
        case .postFavoritePortfolio:
            return "/favorite/portfolio"
        case .deleteFavoriteArtist:
            return "/favorite/artist"
        case .deleteFavoritePortfolio:
            return "/favorite/portfolio"
        }
    }
    
    var error: [Int : NetworkError]? {
        return .none
    }
    
    var headerType: HTTPHeaderFields {
        switch self {
        case .getMyPage, .patchProfile, .getFavoriteArtist, .getFavoritePortfolio, .postFavoriteArtist, .postFavoritePortfolio, .deleteFavoriteArtist, .deleteFavoritePortfolio:
            return .hasAccessToken
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .patchProfile:
            return .patch
        case .getMyPage, .getFavoriteArtist, .getFavoritePortfolio:
            return .get
        case .postFavoriteArtist, .postFavoritePortfolio:
            return .post
        case .deleteFavoriteArtist, .deleteFavoritePortfolio:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .patchProfile(
            modelId: let modelId,
            profileImg: let profileImg,
            nickName: let nickName,
            gender: let gender,
            skinType: let skinType,
            personalColor: let personalColor):
            let parameters: [String: Any] = [
                "model_id": modelId,
                "profile_img": profileImg,
                "nickName": nickName,
                "gender": gender,
                "skin_type": skinType,
                "personal_color": personalColor
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .getMyPage, .getFavoritePortfolio:
            return .requestPlain
        case .getFavoriteArtist(_, let page):
            var params: [String: Any] = [:]
            if let page = page {
                params["page"] = page
                
            }
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .postFavoriteArtist(modelId: let modelId, artistId: let artistId):
            let parameters = [
                "modelId": modelId,
                "artistId": artistId
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .postFavoritePortfolio(modelId: let modelId, portfolioId: let portfolioId):
            let parameters = [
                "modelId": modelId,
                "portfolioId": portfolioId
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .deleteFavoriteArtist(modelId: let modelId, artistId: let artistId):
            let parameters = [
                "modelId": modelId,
                "artistId": artistId
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .deleteFavoritePortfolio(modelId: let modelId, portfolioId: let portfolioId):
            let parameters = [
                "modelId": modelId,
                "portfolioId": portfolioId
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
}
