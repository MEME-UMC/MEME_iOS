//
//  SearchManager.swift
//  MEME
//
//  Created by 정민지 on 2/13/24.
//

import Foundation
import Moya

final class SearchManager {
    typealias API = SearchAPI
    
    static let shared = SearchManager()
    let provider = NetworkProvider<API>(plugins: [NetworkLoggerPlugin()])
    
    private init() {}
    
    // MARK: - 메이크업 검색 관심아티스트 API
    func getSearchArtist(
            artistId: Int,
            page: Int? = nil,
            sort: SearchSort? = nil,
            completion: @escaping (Result<SearchResultDTO, MoyaError>) -> Void
    ) {
        provider.request(api: .getSearchArtist(artistId: artistId, page: page, sort: sort)) { result in
            switch result {
            case .success(let response):
                do {
                    let response = try response.map(SearchResultDTO.self)
                    completion(.success(response))
                } catch {
                    completion(.failure(MoyaError.jsonMapping(response)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - 메이크업 검색 카테고리 API
    func getSearchCategory(
            category: SearchCategory,
            page: Int? = nil,
            sort: SearchSort? = nil,
            completion: @escaping (Result<SearchResultDTO, MoyaError>) -> Void
    ) {
        provider.request(api: .getSearchCategory(category: category, page: page, sort: sort)) { result in
            switch result {
            case .success(let response):
                do {
                    let response = try response.map(SearchResultDTO.self)
                    completion(.success(response))
                } catch {
                    completion(.failure(MoyaError.jsonMapping(response)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - 메이크업 검색 전체조회 API
    func getSearchAll(
            page: Int? = nil,
            sort: SearchSort? = nil,
            completion: @escaping (Result<SearchResultDTO, MoyaError>) -> Void
    ) {
        provider.request(api: .getSearchAll(page: page, sort: sort)) { result in
            switch result {
            case .success(let response):
                do {
                    let response = try response.map(SearchResultDTO.self)
                    completion(.success(response))
                } catch {
                    completion(.failure(MoyaError.jsonMapping(response)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    // MARK: - 메이크업 검색 최근 검색어 API
    func getSearchText(
            query: String,
            page: Int? = nil,
            sort: SearchSort? = nil,
            completion: @escaping (Result<SearchResultDTO, MoyaError>) -> Void
    ) {
        provider.request(api: .getSearchText(query: query, page: page, sort: sort)) { result in
            switch result {
            case .success(let response):
                do {
                    let response = try response.map(SearchResultDTO.self)
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
