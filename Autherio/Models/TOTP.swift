//
//  TOTP.swift
//  Auther
//
//  Created by Kamil Kozioł on 24/04/2021.
//

import Foundation
import UIKit
import CryptoKit


class TOTP: Codable, Identifiable, ObservableObject {
    @Published var secretKey: String
    @Published var issuer: String
    @Published var mail: String
    @Published var digits: Int
    @Published var period: Int
    static let DEFAULT_DIGITS: Int = 6
    static let DEFAULT_PERIOD: Int = 30
    
    static let URL_SCHEME = "otpauth"
    static let URL_HOST = "totp"
    
    init(secretKey: String, issuer: String, mail: String, digits: Int, period: Int) {
        self.secretKey = secretKey
        self.issuer = issuer
        self.mail = mail
        self.digits = digits
        self.period = period
    }
    
    convenience init(secretKey: String) {
        self.init(secretKey: secretKey, issuer: "example.com", mail: "example.com")
    }
    
    convenience init(secretKey: String, issuer: String, mail: String) {
        self.init(secretKey: secretKey, issuer: issuer, mail: mail, digits: Self.DEFAULT_DIGITS, period: Self.DEFAULT_PERIOD)
    }
    
    private func truncateHash(hash: HashedAuthenticationCode<Insecure.SHA1>) -> String {
        var truncatedHash = hash.withUnsafeBytes { ptr -> UInt32 in
            let offset = ptr[hash.byteCount - 1] & 0x0f
            
            let truncatedHashPtr = ptr.baseAddress! + Int(offset)
            return truncatedHashPtr.bindMemory(to: UInt32.self, capacity: 1).pointee
        }
        
        truncatedHash = UInt32(bigEndian: truncatedHash)
        truncatedHash = truncatedHash & 0x7FFF_FFFF
        truncatedHash = truncatedHash % UInt32(pow(10, Float(digits)))
        
        return String(format: "%0\(digits)d", truncatedHash)
    }
    
    func getCode() -> String {
        var counter: UInt64 = UInt64(Date().timeIntervalSince1970 / TimeInterval(period)).bigEndian;
        let secret = base32DecodeToData(secretKey)!
        let counterData = withUnsafeBytes(of: &counter) { Array($0) }
        let hash = HMAC<Insecure.SHA1>.authenticationCode(for: counterData, using: SymmetricKey(data: secret))
        return truncateHash(hash: hash)
    }
    
    func validate(code: String) -> Bool {
        return getCode() == code;
    }
    
    private func escapeString(from str: String) -> String {
        return str.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!
    }
    
    func getURL() -> URL {
        // https://github.com/google/google-authenticator/wiki/Key-Uri-Format
        var components = URLComponents()
        components.scheme = TOTP.URL_SCHEME
        components.host = TOTP.URL_HOST
        components.path = "/\(issuer):\(mail)"
        
        components.queryItems = [
            URLQueryItem(name: "secret", value: secretKey),
            URLQueryItem(name: "issuer", value: issuer),
            URLQueryItem(name: "digits", value: String(digits)),
            URLQueryItem(name: "period", value: String(period)),
        ]
        
        return components.url!
    }
    
    static func parseURL(url: URL) -> TOTP {
        var dict = [String:String]()
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        if let queryItems = components.queryItems {
            for item in queryItems {
                dict[item.name] = item.value!
            }
        }
        
        let issuer = dict["issuer"] ?? ""
//        let mail = url.path.split(separator: ":")[1]
        let digits = Int(dict["digits"] ?? "6")!
        let period = Int(dict["period"] ?? "30")!
        return TOTP(secretKey: dict["secret"]!, issuer: issuer, mail: "test", digits: digits, period: period)
    }
    
    static func getCounter(period: Int) -> Int {
        return period - Int(Date().timeIntervalSince1970)%period
    }
    
    static func getRandomSecretKey() -> String {
        var key = ""
        for _ in 0..<16 {
            key += base32characters.randomElement()!
        }
        return key
    }
    
    static func getRandom() -> TOTP {
        let totp: TOTP = TOTP(secretKey: getRandomSecretKey(), issuer: "Apple", mail: "example@apple.com", digits: Self.DEFAULT_DIGITS, period: Self.DEFAULT_PERIOD)
        return totp
    }
    
    static func isURLValid(url: URL) -> Bool {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        if(components?.scheme != TOTP.URL_SCHEME) {
            return false
        }
        if(components?.host != TOTP.URL_HOST) {
            return false
        }
        
        // TODO: check for good components
        return true
    }
    
    // Codable
    
    
    enum CodingKeys: CodingKey {
        case secretKey
        case issuer
        case mail
        case digits
        case period
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        secretKey = try container.decode(String.self, forKey: .secretKey)
        issuer = try container.decode(String.self, forKey: .issuer)
        mail = try container.decode(String.self, forKey: .mail)
        digits = try container.decode(Int.self, forKey: .digits)
        period = try container.decode(Int.self, forKey: .period)
    }

    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(secretKey, forKey: .secretKey)
        try container.encode(issuer, forKey: .issuer)
        try container.encode(mail, forKey: .mail)
        try container.encode(digits, forKey: .digits)
        try container.encode(period, forKey: .period)
    
    }
}






