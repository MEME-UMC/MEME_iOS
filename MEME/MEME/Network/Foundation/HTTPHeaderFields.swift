//
//  HTTPHeaderFields.swift
//  MEME
//
//  Created by 이동현 on 1/30/24.
//

import Foundation

enum HTTPHeaderFieldsKey {
    static let contentType = "Content-Type"
    static let authorization = "Authorization"
}

enum HTTPHeaderFieldsValue {
    static let html = "application/x-www-form-urlencoded"
    static let json = "application/json"
    static var accessToken: String { "임시 string" }
}

enum HTTPHeaderFields {
    case plain
    case html
    case hasAccessToken
}