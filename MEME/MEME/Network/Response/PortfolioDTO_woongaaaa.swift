//
//  PortfolioDTO.swift
//  MEME
//
//  Created by 황채웅 on 2/14/24.
//

import Foundation

struct CreatePortfolioDTO: Codable {
    let code: Int
    let result: String
    let message: String
    let data: Int
    
    enum CodingKeys: String, CodingKey {
        case code = "statusCode"
        case result
        case message
        case data
    }
}

struct GetAllPortfolioDTO: Codable {
    let result: String
    let message: String
    let data: PortfolioData?
    let statusCode: Int
}

struct PortfolioData: Codable {
    let content: [PortfolioResultData]?
    let currentPage: Int
    let pageSize: Int
    let totalNumber: Int?
    let totalPage: Int
}

struct PortfolioResultData: Codable {
    let portfolioId: Int
    let category: String
    let artistNickName: String
    let makeupName: String
    let price: Int
    let makeupLocation: String
    let shopLocation: String?
    let region: [String]?
    let isBlock: Bool
    let averageStars: String
    let reviewCount: Int
    let portfolioImgDtoList: [ImageData]?
}

struct ImageData: Codable {
    let portfolioImgId: Int
    let portfolioImgSrc: String
    let delete: Bool
}

struct EditPortfolioDTO: Codable {
    struct Response: Codable {
        let code: Int
        let result: String
        let message: String
        let data: PortfolioData?
    }
}
