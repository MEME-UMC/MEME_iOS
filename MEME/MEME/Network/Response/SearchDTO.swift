//
//  SearchDTO.swift
//  MEME
//
//  Created by 정민지 on 2/13/24.
//

import Foundation

// MARK: -메이크업 검색 DTO
struct SearchResultDTO: Codable {
    let result: String
    let message: String
    let data: SearchData?
    let statusCode: Int
}

struct SearchData: Codable {
    let content: [PortfolioData]?
}

struct PortfolioData: Codable {
    let portfolioId: Int
    let category: String
    let artistNickName: String
    let makeupName: String
    let price: Int
    let info: String?
    let makeupLocation: String
    let shopLocation: String?
    let region: [String]?
    let isBlock: Bool
    let averageStars: Float
    let reviewCount: Int
    let portfolioImgDtoList: ImageData?
}

struct ImageData: Codable {
    let portfolioImgId: Int
    let portfolioImgSrc: String
    let delete: Bool
    
}
