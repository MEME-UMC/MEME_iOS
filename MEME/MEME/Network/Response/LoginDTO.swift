//
//  LoginDTO.swift
//  MEME
//
//  Created by 이동현 on 3/28/24.
//

import Foundation

struct LoginDTO: Codable {
    let isUser: Bool
    let id: Int
    let accessToken: String
    let refreshToken: String

    enum CodingKeys: String, CodingKey {
        case isUser, id
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
