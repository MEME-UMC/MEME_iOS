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
        profileInfo: ProfileInfo,
        completion: @escaping (Result<SignUpResponseDTO, MoyaError>) -> Void
    ) {
        guard
            let gender = profileInfo.gender,
            let skinType = profileInfo.skinType,
            let personalColor = profileInfo.personalColor
        else { return }
        provider.request(api: .modelSignUp(
            idToken: profileInfo.id_token,
            provider: profileInfo.provider,
            profileImg: profileInfo.profileImg,
            username: profileInfo.username,
            nickname: profileInfo.nickname,
            gender: gender,
            skinType: skinType,
            personalColor: personalColor
        )) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONDecoder().decode(SignUpResponseDTO.self, from: response.data)
                    completion(.success(data))
                } catch let error {
                    print("Error decoding : \(error)")
                    completion(.failure(MoyaError.jsonMapping(response)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func artistsignUp(
        profileInfo: ProfileInfo,
        completion: @escaping (Result<SignUpResponseDTO, MoyaError>) -> Void
    ) {
        provider.request(api: .artistSignUp(
            idToken: profileInfo.id_token,
            provider: profileInfo.provider,
            profileImg: profileInfo.profileImg,
            username: profileInfo.username,
            nickname: profileInfo.nickname
        )) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONDecoder().decode(SignUpResponseDTO.self, from: response.data)
                    completion(.success(data))
                } catch let error {
                    print("Error decoding : \(error)")
                    completion(.failure(MoyaError.jsonMapping(response)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func setArtistProfile(
        extraInfo: AtristProfileInfo,
        completion: @escaping (Result<ExtraProfileResponseDTO, MoyaError>) -> Void
    ) {
        provider.request(api: .artistProfile(
            userId: extraInfo.userId,
            profileImg: extraInfo.profileImg,
            nickName: extraInfo.nickName,
            gender: extraInfo.gender,
            introduction: extraInfo.introduction,
            workExperience: extraInfo.workExperience,
            region: extraInfo.region,
            specialization: extraInfo.specialization,
            makeupLocation: extraInfo.makeupLocation,
            shopLocation: extraInfo.shopLocation,
            week: extraInfo.week,
            selectedTime: extraInfo.selectedTime
        )) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONDecoder().decode(ExtraProfileResponseDTO.self, from: response.data)
                    completion(.success(data))
                } catch let error {
                    print("Error decoding : \(error)")
                    completion(.failure(MoyaError.jsonMapping(response)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
            
        }
    }
    
    func reissue(completion: @escaping (Result<TokenResponseDTO, MoyaError>) -> Void) {
        
        let accessToken = KeyChainManager.read(forkey: .accessToken) ?? ""
        let refreshToken = KeyChainManager.read(forkey: .refreshToken) ?? ""
        
        provider.request(api: .reissue(
            accessToken: accessToken,
            refreshToken: refreshToken
        )) { result in
            switch result {
            case .success(let response):
                do {
                    let tokens = try JSONDecoder().decode(TokenResponseDTO.self, from: response.data)
                    completion(.success(tokens))
                } catch let error {
                    print("Error decoding : \(error)")
                    completion(.failure(MoyaError.jsonMapping(response)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func login(
        idToken: String,
        socialProvider: SocialProvider,
        completion: @escaping (Result<LoginDTO, MoyaError>) -> Void
    ) {
        provider.request(api: .login(idToken: idToken, provider: socialProvider)) { result in
            switch result {
            case .success(let response):
                do {
                    let loginResult = try JSONDecoder().decode(LoginDTO.self, from: response.data)
                    completion(.success(loginResult))
                } catch let error {
                    completion(.failure(MoyaError.jsonMapping(response)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
