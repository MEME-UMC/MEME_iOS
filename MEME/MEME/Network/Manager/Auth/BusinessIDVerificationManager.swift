//
//  BusinessIDVerificationManager.swift
//  MEME
//
//  Created by 이동현 on 2/2/24.
//

import Foundation
import Moya

final class BusinessIDVerificationManager {
    typealias API = BusinessIDVerificationAPI
    static let shared = BusinessIDVerificationManager()
    private lazy var provider = MoyaProvider<API>(plugins: [NetworkLoggerPlugin()])
    
    private init() {}
    
    func verifyId(
        id: String,
        name: String,
        date: String,
        completion: @escaping (Result<BusinessVerificationDTO, Error>) -> Void
    ) {
        provider.request(.verifyId(id: id, name: name, date: date)) { result in
            switch result {
            case let .success(response):
                do {
                    let businessVerificationDTO = try response.map(BusinessVerificationDTO.self)
                    completion(.success(businessVerificationDTO))
                } catch {
                    completion(.failure(error))
                }               
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
