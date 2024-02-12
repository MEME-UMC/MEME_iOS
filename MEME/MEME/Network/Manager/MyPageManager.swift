//
//  MyPageManager.swift
//  MEME
//
//  Created by 정민지 on 2/13/24.
//

import Foundation
import Moya

final class MyPageManager {
    typealias API = MyPageAPI
    
    static let shared = MyPageManager()
    let provider = NetworkProvider<API>(plugins: [NetworkLoggerPlugin()])
    
    private init() {}
    
    // MARK: -관심 아티스트 조회 API
    func getFavoriteArtists(
        modelId: Int,
        page: Int? = nil,
        completion: @escaping (Result<FavoriteArtistsDTO, MoyaError>) -> Void
    ) {
        var params: [String: Any] = [:]
        if let page = page {
            params["page"] = page
        }
        
        provider.request(api: .getFavoriteArtist(
            modelId: modelId,
            page: page
        )) { result in
            switch result {
            case .success(let response):
                do {
                    let artists = try JSONDecoder().decode(FavoriteArtistsDTO.self, from: response.data)
                    completion(.success(artists))
                } catch let error {
                    print("Error decoding favorite artists: \(error)")
                    completion(.failure(MoyaError.encodableMapping(error)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: -관심 메이크업 추가 API
    func postFavoritePortfolio(
        modelId: Int,
        portfolioId: Int,
        completion: @escaping (Result<FavoritePortfolioDTO, MoyaError>) -> Void
    ) {
        provider.request(api: .postFavoritePortfolio(modelId: modelId, portfolioId: portfolioId)) { result in
            switch result {
            case .success(let response):
                if let dataString = String(data: response.data, encoding: .utf8) {
                            print("Response Data: \(dataString)")
                        } else {
                            print("Failed to convert response data to string.")
                        }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    
    // MARK: -관심 메이크업 삭제 API
    func deleteFavoritePortfolio(
        modelId: Int,
        portfolioId: Int,
        completion: @escaping (Result<FavoritePortfolioDTO, MoyaError>) -> Void
    ) {
        provider.request(api: .deleteFavoritePortfolio(modelId: modelId, portfolioId: portfolioId)) { result in
            switch result {
            case .success(let response):
                if let dataString = String(data: response.data, encoding: .utf8) {
                            print("Response Data: \(dataString)")
                        } else {
                            print("Failed to convert response data to string.")
                        }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }


    

}
