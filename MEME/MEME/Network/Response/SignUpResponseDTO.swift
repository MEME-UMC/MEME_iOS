//
//  SignUpResponseDTO.swift
//  MEME
//
//  Created by 이동현 on 2/17/24.
//

import Foundation

struct UserId: Codable {
    let userId: Int
    
    enum CodingKeys: String, CodingKey {
        case userId
    }
}
