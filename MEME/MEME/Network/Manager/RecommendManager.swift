//
//  RecommendManager.swift
//  MEME
//
//  Created by 정민지 on 2/14/24.
//

import Foundation
import Moya

final class RecommendManager {
    typealias API = RecommendAPI
    
    static let shared = RecommendManager()
    let provider = NetworkProvider<API>(plugins: [NetworkLoggerPlugin()])
    
    private init() {}
    
    // MARK: -아티스트 추천 (리뷰순) API
    func getRecommendArtistByReview(
        completion: @escaping (Result<RecommendDTO, MoyaError>) -> Void
    ) {
        provider.request(api: .getRecommendArtistByReview) { result in
            switch result {
            case .success(let response):
                do {
                    let response = try response.map(RecommendDTO.self)
                    completion(.success(response))
                } catch {
                    completion(.failure(MoyaError.jsonMapping(response)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: -아티스트 추천 (최신 등록 순) API
    func getRecommendArtistByRecent(
        completion: @escaping (Result<RecommendDTO, MoyaError>) -> Void
    ) {
        provider.request(api: .getRecommendArtistByRecent) { result in
            switch result {
            case .success(let response):
                do {
                    let response = try response.map(RecommendDTO.self)
                    completion(.success(response))
                } catch {
                    completion(.failure(MoyaError.jsonMapping(response)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
