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
    static var accessToken: String { "Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJtZW1lX3VtYyIsImlhdCI6MTcwNzk4NTkwOSwiZXhwIjoxNzEwNTc3OTA5LCJzdWIiOiJhY2Nlc3MtdG9rZW4iLCJ1c2VybmFtZSI6IuyehOyerOyYgSIsInJvbGUiOiJST0xFX01PREVMIn0.8MSYAcPOl6IfxOARHAS_aiYhG6JaQ1NjkuKqt_mZJEKgRLOxHkxHqbzZ2fmoq4Il1EVj3ieOU6Uq2WHFPcPZ6g" }
}

enum HTTPHeaderFields {
    case plain
    case html
    case hasAccessToken
}
