//
//  RecommendDTO.swift
//  MEME
//
//  Created by 정민지 on 2/14/24.
//

import Foundation

// MARK: -아티스트 추천 DTO
struct RecommendDTO: Codable {
    let result: String
    let message: String
    let data: [Portfolio]
    let statusCode: Int
}

struct Portfolio: Codable {
    let portfolioId: Int
    let portfolioImg: String
    let category: String
    let makeupName: String
    let artistName: String
    let price: Int
    let makeupLocation: String?
}

