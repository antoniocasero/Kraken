//
//  Operations.swift
//  KrakenClient
//
//  Created by Antonio Casero Palmero on 24.07.17.
//  Copyright © 2017 Antonio Casero Palmero. All rights reserved.
//

import Foundation

public struct Network {

    enum RequestType: String {
        case publicRequest = "public"
        case privateRequest = "private"
    }

    public typealias AsyncOperation = (Result<[String : Any]>) -> Void
    private let credentials: Kraken.Credentials
    let version = "0"
    let krakenUrl = "api.kraken.com"
    let scheme = "https"

    init(credentials: Kraken.Credentials) {
        self.credentials = credentials

    }

    private func createURL(with method: String, params: [String:String], type: RequestType) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = krakenUrl
        urlComponents.path =  "/" + version + "/" + type.rawValue + "/" + method
        return urlComponents.url
    }

    private func encode(params: [String : String]) -> String {
        var urlComponents = URLComponents()
        var parameters: [URLQueryItem] = []
        let parametersDictionary = params

        for (key, value) in parametersDictionary {
            let newParameter = URLQueryItem(name: key, value: value)
            parameters.append(newParameter)
        }

        urlComponents.queryItems = parameters
        return urlComponents.url?.query ?? ""
    }

    func getRequest(with method: String, params: [String : String]? = [:], type: RequestType = .publicRequest,
                    completion: @escaping AsyncOperation) {
        let params = params ?? [:]
        guard let url = createURL(with: method, params:params, type: type) else {
            fatalError()
        }

        let request = URLRequest(url: url)
        rawRequest(request, completion: completion)
    }

    func postRequest(with path: String, params: [String : String]?, type: RequestType = .privateRequest,
                     completion: @escaping AsyncOperation) {

        let params = addNonce(to:params)
        let urlParams = encode(params: params)

        guard let url = createURL(with: path, params: params, type: type),
            let signature = try? generateSignature(url, params:params) else {
                fatalError()
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = urlParams.data(using: .utf8)
        request.setValue(credentials.apiKey, forHTTPHeaderField: "API-Key")
        request.setValue(signature, forHTTPHeaderField: "API-Sign")
        for (key, value) in params {
            request.setValue(value, forHTTPHeaderField: key)
        }
        rawRequest(request, completion: completion)
    }

    private func rawRequest(_ request: URLRequest, completion: @escaping AsyncOperation) {

        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            guard let data = data, let _ = response else {
                return completion(.failure(error!))
            }
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as? [String : AnyObject] else {
                    return completion(.failure(KrakenError.errorNetworking(reason: "Wrong JSON structure")))
                }
                if let errorArray = json["error"] as? [String] {
                    if !errorArray.isEmpty {
                        return completion(.failure(KrakenError.errorAPI(reason: errorArray.first!)))
                    }
                }
                return completion(.success(json))

            } catch let error as NSError {
                return completion(.failure(KrakenError.errorNetworking(reason: "Error JSON parsing: \(error.localizedDescription)")))
            }

            }.resume()
    }

    private func generateSignature(_ url: URL, params: [String:String]) throws  -> String {

        let path = url.path
        let encodedParams = encode(params: params)
        guard let decodedSecret = Data(base64Encoded: credentials.apiSecret),
            let nonce = params["nonce"],
            let digest = (nonce + encodedParams).data(using: .utf8),
            let encodedPath = path.data(using: .utf8) else {
                throw KrakenError.errorAPI(reason: "Error encoding signature")
        }

        let message = digest.SHA256()
        let messagePath = encodedPath + message

        let signature = HMAC.sign(data: messagePath, algorithm: HMAC.Algorithm.sha512, key: decodedSecret)
        return signature.base64EncodedString()
    }

    private func addNonce(to params: [String : String]?) -> [String: String] {
        var paramsWithNonce = params ?? [:]
        let nonce = String(Int(Date().timeIntervalSinceReferenceDate.rounded()*1000))
        paramsWithNonce["nonce"] = nonce
        return paramsWithNonce

    }
}
