//
//  BasicResponseDTO.swift
//  MEME
//
//  Created by 이동현 on 2/17/24.
//

import Foundation

struct BasicResponseDTO<T: Codable>: Codable {
    let code: Int
    let result: String
    let message: String
    let data: T
    
    enum CodingKeys: String, CodingKey {
        case code, result, message, data
    }
}

struct EmptyData: Codable {
    
}
