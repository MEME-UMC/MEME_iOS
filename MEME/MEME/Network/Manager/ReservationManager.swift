//
//  ReservationManager.swift
//  MEME
//
//  Created by 이동현 on 2/3/24.
//

import Foundation
import Moya

final class ReservationManager {
    typealias API = ReservationAPI
    
    static let shared = ReservationManager()
    let provider = NetworkProvider<API>(plugins: [NetworkLoggerPlugin()])
    
    private init() {}
    
    // MARK: -예약하기 API
    func postReservation(
        modelId: Int,
        portfolioId: Int,
        date: String,
        time: ReservationTimes,
        dayOfWeek: DayOfWeek,
        location: String,
        completion: @escaping (Result<PostReservationDTO, MoyaError>) -> Void
    ) {
        provider.request(api: .postReservation(
            modelId: modelId,
            portfolioId: portfolioId,
            date: date,
            time: time,
            dayOfWeek: dayOfWeek,
            location: location
        )) { result in
            switch result {
            case .success(let response):
                do {
                    let reservationResponse = try JSONDecoder().decode(PostReservationDTO.self, from: response.data)
                    completion(.success(reservationResponse))
                } catch let error {
                    completion(.failure(MoyaError.underlying(error, response)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: -아티스트 예약 가능 장소 조회 API
    func getPossibleLocation(
        aristId: Int,
        completion: @escaping (Result<PossibleLocationsDTO, MoyaError>) -> Void
    ) {
        provider.request(api: .getPossibleLocation(
            aristId: aristId
        )) { result in
            switch result {
            case .success(let response):
                do {
                    let locations = try JSONDecoder().decode(PossibleLocationsDTO.self, from: response.data)
                    completion(.success(locations))
                    print("성공: \(locations)")
                } catch let error {
                    completion(.failure(MoyaError.underlying(error, response)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    // MARK: -아티스트 예약 가능 시간 조회 API
    func getPossibleTime(
        aristId: Int,
        completion: @escaping (Result<PossibleTimesDTO, MoyaError>) -> Void
    ) {
        provider.request(api: .getPossibleTime(
            aristId: aristId
        )) { result in
            switch result {
            case .success(let response):
                do {
                    let timesDTO = try JSONDecoder().decode(PossibleTimesDTO.self, from: response.data)
                    completion(.success(timesDTO))
                    print("성공: \(timesDTO)")
                } catch {
                    completion(.failure(MoyaError.underlying(error, response)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: -모델 예약 조회 API
    func getModelReservation(
        modelId: Int,
        completion: @escaping (Result<ReservationDTO, MoyaError>) -> Void
    ) {
        provider.request(api: .getModelReservation(modelId: modelId)) { result in
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
    
    // MARK: -예약 상태 변경 API
//    func alterationReservation(
//        reservationId: Int,
//        status: String,
//        completion: @escaping (Result<alterationReservationDTO, MoyaError>) -> Void
//    ) {
//        provider.request(api: .alterationReservation(reservationId: Int,
//                                                     status: String)) { result in
//            switch result {
//            case .success(let response):
//                do {
//                    let updateResponse = try JSONDecoder().decode(alterationReservationDTO.self, from: response.data)
//                    completion(.success(updateResponse))
//                } catch let error {
//                    completion(.failure(MoyaError.underlying(error, response)))
//                }
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
}
