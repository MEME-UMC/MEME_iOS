//
//  AuthAPI.swift
//  MEME
//
//  Created by 이동현 on 2/3/24.
//

import Foundation
import Moya

enum SocialProvider: String {
    case APPLE
    case KAKAO
}

enum AuthAPI {
    case login(idToken: String, provider: SocialProvider)
    case logout
    case withdraw
    case modelSignUp(
        email: String,
        provider: SocialProvider,
        profileImg: String,
        username: String,
        nickname: String,
        gender: Gender,
        skinType: String, //임시
        personalColor: String //임시
    )
    case artistSignUp(
        email: String,
        provider: SocialProvider,
        profileImg: String,
        username: String,
        nickname: String
    )
    case artistProfile(
        userId: Int,
        profileImg: String,
        nickName: String,
        gender: Gender,
        introduction: String,
        workExperience: String,
        region: [String],
        specialization: [String],
        makeupLocation: String,
        shopLocation: String,
        availableDayOfWeekAndTime: String //임시
    )
    case reissue(accessToken: String, refreshToken: String)
}

extension AuthAPI: MemeAuthAPI {
    var domain: MemeAuthDomain {
        return .auth
    }

    var urlPath: String {
        switch self {
        case .login:
            return "/login"
        case .logout:
            return "/logout"
        case .withdraw:
            return "/withdraw"
        case .modelSignUp:
            return "/model/signup"
        case .artistSignUp:
            return "/artist/signup"
        case .artistProfile:
            return "/artist/extra"
        case .reissue:
            return "/reissue"
        }
    }
    
    var error: [Int : NetworkError]? {
        return nil
    }
    
    var headerType: HTTPHeaderFields {
        switch self {
        case .login, .modelSignUp, .artistSignUp, .artistProfile, .reissue:
            return .plain
        case .logout, .withdraw:
            return .hasAccessToken
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Moya.Task {
        switch self {
            
        case .login(idToken: let idToken, provider: let provider):
            let parameters: [String: Any] = [
                "id_token": idToken,
                "provider": provider.rawValue
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .logout:
            return .requestPlain
            
        case .withdraw:
            return .requestPlain
            
        case .modelSignUp(
            email: let email,
            provider: let provider,
            profileImg: let profileImg,
            username: let username,
            nickname: let nickname,
            gender: let gender,
            skinType: let skinType,
            personalColor: let personalColor
        ):
            let parameters: [String: Any] = [
                "email": email,
                "provider": provider.rawValue,
                "profileImg": profileImg,
                "username": username,
                "nickname": nickname,
                "gender": gender.rawValue,
                "skinType": skinType,
                "personalColor": personalColor
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .artistSignUp(
            email: let email,
            provider: let provider,
            profileImg: let profileImg,
            username: let username,
            nickname: let nickname
        ):
            let parameters: [String: Any] = [
                "email": email,
                "provider": provider.rawValue,
                "profileImg": profileImg,
                "username": username,
                "nickname": nickname
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .artistProfile(
            userId: let userId,
            profileImg: let profileImg,
            nickName: let nickName,
            gender: let gender,
            introduction: let introduction,
            workExperience: let workExperience,
            region: let region,
            specialization: let specialization,
            makeupLocation: let makeupLocation,
            shopLocation: let shopLocation,
            availableDayOfWeekAndTime: let availableDayOfWeekAndTime
        ):
            let parameters: [String: Any] = [
                "userId": userId,
                "profileImg": profileImg,
                "nickname": nickName,
                "gender": gender.rawValue,
                "introduction": introduction,
                "workExperience": workExperience,
                "region": region,
                "specialization": specialization,
                "makeupLocation": makeupLocation,
                "shopLocation": shopLocation,
                "availableDayOfWeekAndTime": availableDayOfWeekAndTime
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .reissue(accessToken: let accessToken, refreshToken: let refreshToken):
            let parameters: [String: Any] = [
                "accessToken": accessToken,
                "refreshToken": refreshToken
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
}
