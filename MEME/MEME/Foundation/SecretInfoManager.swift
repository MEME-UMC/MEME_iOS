//
//  SecretInfoManager.swift
//  MEME
//
//  Created by 이동현 on 2/3/24.
//

import Foundation

enum SecretInfoKeys {
    static let clientID = "ClientID"
    static let callbackURLScheme = "CallbackURLScheme"
    static let baseURL = "BaseURL"
    static let baseURLAuth = "BaseURLAuth"
    static let imageBaseURL = "ImageBaseURL"
    static let s3Secret = "S3SecretKey"
    static let s3Access = "S3AccessKey"
}

final class SecretInfoManager {
    
    static let shared = SecretInfoManager()
    
    class var clientID: String {
        guard let id = shared.info[SecretInfoKeys.clientID] else { fatalError("ClientID: Base-Info Plist error") }
        return id
    }
    
    class var callbackURLScheme: String {
        guard let scheme = shared.info[SecretInfoKeys.callbackURLScheme] else { fatalError("CallbackURLScheme: Base-Info Plist error") }
        return scheme
    }
    
    class var baseURL: String {
        guard let url = shared.info[SecretInfoKeys.baseURL] else { fatalError("BaseURL: Base-Info Plist error")}
        return url
    }
    
    class var baseURLAuth: String {
        guard let url = shared.info[SecretInfoKeys.baseURLAuth] else { fatalError("BaseURL: Base-Info Plist error")}
        return url
    }
    
    class var imageBaseURL: String {
        guard let url = shared.info[SecretInfoKeys.imageBaseURL] else { fatalError("ImageBaseURL: Base-Info Plist error")}
        return url
    }
    
    class var s3SecretKey: String {
        guard let key = shared.info[SecretInfoKeys.s3Secret] else { fatalError("s3Secret: Base-Info Plist error")}
        return key
    }
    
    class var s3AccessKey: String {
        guard let key = shared.info[SecretInfoKeys.s3Access] else { fatalError("s3Access: Base-Info Plist error")}
        return key
    }
    
    private var info: [String: String] {
        guard let plistPath = Bundle.main.path(forResource: "memeSecret", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: plistPath) as? [String: String] else {
            return [:]
        }
        return plist
    }
}
