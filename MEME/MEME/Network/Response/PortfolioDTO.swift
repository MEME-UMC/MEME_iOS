//
//  PortfolioDTO_woongaaaa.swift
//  MEME
//
//  Created by 황채웅 on 2/14/24.
//

import Foundation

struct CreatePortfolioDTO: Codable {
    let statusCode: Int
    let result: String
    let message: String
    let data: Int
}

struct GetAllPortfolioDTO: Codable {
    let result: String
    let message: String
    let data: PortfolioData?
    let statusCode: Int
}

struct PortfolioData: Codable {
    let content: [PortfolioAllData]?
    let currentPage: Int
    let pageSize: Int
    let totalNumber: Int?
    let totalPage: Int
}

struct PortfolioAllData: Codable {
    let portfolioId: Int
    let category, artistNickName: String
    let userId: Int
    let makeupName: String
    let price: Int
    let makeupLocation, shopLocation: String
    let region: [String]
    let isBlock: Bool
    let averageStars: String
    let reviewCount: Int
    let portfolioImgDtoList: [PortfolioImgDtoList]
}
struct PortfolioImgDtoList: Codable {
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
// MARK: -포트폴리오 세부 조회 DTO
struct PortfolioDTO: Codable {
    let result: String
    let message: String
    let data: PortfolioDetailData?
    let statusCode: Int
}

struct PortfolioDetailData: Codable {
    let portfolioId: Int
    let userId: Int
    let isFavorite: Bool
    let category: String
    let artistProfileImg: String
    let artistNickName: String
    let makeupName: String
    let price: Int
    let info: String
    let makeupLocation: String
    let shopLocation: String?
    let region: [String]?
    let isBlock: Bool
    let averageStars: String
    let reviewCount: Int
    let portfolioImgDtoList: [ImageData]?
}
