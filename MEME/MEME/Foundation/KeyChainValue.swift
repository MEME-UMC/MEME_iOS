//
//  KeyChainValue.swift
//  MEME
//
//  Created by 이동현 on 2/3/24.
//

import Foundation

enum KeyChainValue: String, CaseIterable {
    
    case accessToken = "accessToken"
    case refreshToken = "refreshToken"
    case memberId = "id"
    case role = "role"
    case nickName = "nickName"
}
