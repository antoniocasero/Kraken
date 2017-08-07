//
//  Crypto.swift
//  Kraken
//
//  Created by Antonio Casero Palmero on 30.07.17.
//  Copyright © 2017 Antonio Casero Palmero. All rights reserved.
//

import Foundation
import CommonCrypto

public struct HMAC {

    // MARK: - Types
    public enum Algorithm {
        case sha1
        case md5
        case sha256
        case sha384
        case sha512
        case sha224

        public var algorithm: CCHmacAlgorithm {
            switch self {
            case .md5: return CCHmacAlgorithm(kCCHmacAlgMD5)
            case .sha1: return CCHmacAlgorithm(kCCHmacAlgSHA1)
            case .sha224: return CCHmacAlgorithm(kCCHmacAlgSHA224)
            case .sha256: return CCHmacAlgorithm(kCCHmacAlgSHA256)
            case .sha384: return CCHmacAlgorithm(kCCHmacAlgSHA384)
            case .sha512: return CCHmacAlgorithm(kCCHmacAlgSHA512)
            }
        }

        public var digestLength: Int {
            switch self {
            case .md5: return Int(CC_MD5_DIGEST_LENGTH)
            case .sha1: return Int(CC_SHA1_DIGEST_LENGTH)
            case .sha224: return Int(CC_SHA224_DIGEST_LENGTH)
            case .sha256: return Int(CC_SHA256_DIGEST_LENGTH)
            case .sha384: return Int(CC_SHA384_DIGEST_LENGTH)
            case .sha512: return Int(CC_SHA512_DIGEST_LENGTH)
            }
        }
    }

    // MARK: - Signing
    public static func sign(data: Data, algorithm: Algorithm, key: Data) -> Data {
        let signature = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: algorithm.digestLength)
        defer { signature.deallocate(capacity: algorithm.digestLength) }

        data.withUnsafeBytes { dataBytes in
            key.withUnsafeBytes { keyBytes in
                CCHmac(algorithm.algorithm, keyBytes, key.count, dataBytes, data.count, signature)
            }
        }

        return Data(bytes: signature, count: algorithm.digestLength)
    }
}

extension String {

    func base64Decoded() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }

    func base64Encoded() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}

extension Data {

    func MD5() -> Data {
        var result = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        _ = result.withUnsafeMutableBytes {resultPtr in
            self.withUnsafeBytes {(bytes: UnsafePointer<UInt8>) in
                CC_MD5(bytes, CC_LONG(count), resultPtr)
            }
        }
        return result
    }
    func SHA1() -> Data {
        var result = Data(count: Int(CC_SHA1_DIGEST_LENGTH))
        _ = result.withUnsafeMutableBytes {resultPtr in
            self.withUnsafeBytes {(bytes: UnsafePointer<UInt8>) in
                CC_SHA1(bytes, CC_LONG(count), resultPtr)
            }
        }
        return result
    }
    func SHA256() -> Data {
        var result = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
        _ = result.withUnsafeMutableBytes {resultPtr in
            self.withUnsafeBytes {(bytes: UnsafePointer<UInt8>) in
                CC_SHA256(bytes, CC_LONG(count), resultPtr)
            }
        }
        return result
    }
}
