//
//  MyPageManager.swift
//  MEME
//
//  Created by 이동현 on 2/3/24.
//

import Foundation
import Moya

final class AuthManager {
    typealias API = AuthAPI
    
    static let shared = AuthManager()
    let provider = NetworkAuthProvider<API>(plugins: [NetworkLoggerPlugin()])
    
    private init() {}
    
    func login(
        idToken: String,
        socialProvider: SocialProvider,
        completion: @escaping (Result<Response, MoyaError>) -> Void
    ) {
        provider.request(api: .login(idToken: idToken, provider: socialProvider)) { result in
            completion(result)
        }
    }
    
    func logout(completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(api: .logout) { reslut in
            completion(reslut)
        }
    }
    
    func withdraw(completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(api: .withdraw) { reslut in
            completion(reslut)
        }
    }
    
    func modelSignUp(
        email: String,
        socialProvider: SocialProvider,
        profileImg: String,
        username: String,
        nickname: String,
        gender: Gender,
        skinType: String,
        personalColor: String,
        completion: @escaping (Result<Response, MoyaError>) -> Void
    ) {
        provider.request(api: .modelSignUp(
            email: email,
            provider: socialProvider,
            profileImg: profileImg,
            username: username,
            nickname: nickname,
            gender: gender,
            skinType: skinType,
            personalColor: personalColor
        )) { result in
            completion(result)
        }
    }
    
    func artistsignUp(
        email: String,
        socialProvider: SocialProvider,
        profileImg: String,
        username: String,
        nickname: String,
        completion: @escaping (Result<Response, MoyaError>) -> Void
    ) {
        provider.request(api: .artistSignUp(
            email: email,
            provider: socialProvider,
            profileImg: profileImg,
            username: username,
            nickname: nickname
        )) { result in
            completion(result)
        }

    }
    
    func setArtistProfile(
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
        availableDayOfWeekAndTime: String,
        completion: @escaping (Result<Response, MoyaError>) -> Void
    ) {
        provider.request(api: .artistProfile(
            userId: userId,
            profileImg: profileImg,
            nickName: nickName,
            gender: gender,
            introduction: introduction,
            workExperience: workExperience,
            region: region,
            specialization: specialization,
            makeupLocation: makeupLocation,
            shopLocation: shopLocation,
            availableDayOfWeekAndTime: availableDayOfWeekAndTime
        )) { result in
            completion(result)
        }
    }
    
    func reissue(
        accessToken: String,
        refreshToken: String,
        completion: @escaping (Result<Response, MoyaError>) -> Void
    ) {
        provider.request(api: .reissue(
            accessToken: accessToken,
            refreshToken: refreshToken
        )) { result in
            completion(result)
        }
    }
}
