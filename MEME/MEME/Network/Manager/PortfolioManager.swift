//
//  PortfolioManager.swift
//  MEME
//
//  Created by 황채웅 on 2/12/24.
//

import Foundation
import Moya

final class PortfolioManager {
    typealias API = PortfolioAPI
    
    static let shared = PortfolioManager()
    let provider = NetworkProvider<API>(plugins: [NetworkLoggerPlugin()])
    
    private init() {}
    
    func createPortfolio(
        artistId: Int,
        category: PortfolioCategories,
        makeup_name: String,
        price: Int,
        info: String,
        portfolio_img_src: [String],
        completion: @escaping (Result<CreatePortfolioDTO, Error>) -> Void
    ){
        provider.request(api: .createPortfolio(artistId: artistId, category: category, makeup_name: makeup_name, price: price, info: info, portfolio_img_src: portfolio_img_src)) { result in
            switch result {
                case let .success(response):
                    do {
                        let dto = try response.map(CreatePortfolioDTO.self)
                        completion(.success(dto))
                    } catch {
                        completion(.failure(error))
                    }
                case let .failure(error):
                    completion(.failure(error))
            }
        }
    }
    func getAllPortfolio(
        artistId: Int,
        page: Int,
        completion: @escaping (Result<GetAllPortfolioDTO, Error>) -> Void
    ) {
        provider.request(api: .getAllPortfolio(artistId: artistId, page: page)) { result in
            switch result {
            case let .success(response):
                do {
                    let dto = try response.map(GetAllPortfolioDTO.self)
                    completion(.success(dto))
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    func editPortfolio(
        artistId: Int,
        portfolioId: Int,
        category: PortfolioCategories,
        makeup_name: String,
        price: Int,
        info: String,
        isBlock: Bool,
        portfolio_img_src: [String],
        completion: @escaping (Result<EditPortfolioDTO.Response, Error>) -> Void
    ) {
        provider.request(api: .editPortfolio(artistId: artistId, portfolioId: portfolioId, category: category, makeup_name: makeup_name, price: price, info: info, isBlock: isBlock, portfolio_img_src: portfolio_img_src)) { result in
            switch result {
                case let .success(response):
                    do {
                        let dto = try response.map(EditPortfolioDTO.Response.self)
                        completion(.success(dto))
                    } catch let error {
                        completion(.failure(error))
                    }
                case let .failure(error):
                    completion(.failure(error))
            }
        }
    }
}
