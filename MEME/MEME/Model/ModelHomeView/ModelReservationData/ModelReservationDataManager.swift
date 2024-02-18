//
//  ModelReservationDataManager.swift
//  MEME
//
//  Created by 정민지 on 1/15/24.
//

import Foundation
import Moya

class ShowModelReservationDataManager {
    static let shared = ShowModelReservationDataManager()
    let provider = MoyaProvider<ReservationAPI>()
    
    // MARK: 모델 예약 조회 API
    func getModelReservation(modelId: Int, completion: @escaping (Result<ReservationDTO, MoyaError>) -> Void) {
        provider.request(.getModelReservation(modelId: modelId)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(ReservationDTO.self, from: response.data)
                    completion(.success(decodedData))
                } catch let error {
                    completion(.failure(MoyaError.underlying(error, response)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
