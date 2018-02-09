//
//  Kraken.swift
//  KrakenClient
//
//  Created by Antonio Casero Palmero on 23.07.17.
//  Copyright © 2017 Antonio Casero Palmero. All rights reserved.
//

import Foundation

public struct Kraken {
    
    public struct Credentials {
        var apiKey: String
        var apiSecret: String
        
        public init(key: String, secret: String) {
            apiKey = key
            apiSecret = secret
        }
    }
    
    private let request: Network
    
    // MARK: Public methods
    
    public init(credentials: Credentials) {
        request = Network(credentials: credentials)
    }
    
    public func serverTime(completion: @escaping Network.AsyncOperation) {
        request.getRequest(with: "Time", completion:completion)
    }
    
    public func assets(options: [String:String]? = nil, completion: @escaping Network.AsyncOperation) {
        request.getRequest(with: "Assets", params: options, completion:completion)
    }
    
    public func assetPairs(options: [String:String]? = nil, completion: @escaping Network.AsyncOperation) {
        request.getRequest(with: "AssetPairs", params: options, completion:completion)
    }
    
    public func ticker(pairs: [String], options: [String:String]? = nil, completion: @escaping Network.AsyncOperation) {
        var optionsCopy = options ?? [:]
        optionsCopy["pair"] = pairs.joined(separator: ",")
        request.getRequest(with: "Ticker", params:optionsCopy, completion:completion)
    }
    
    public func orderBook(pairs: [String], options: [String:String]? = nil, completion: @escaping Network.AsyncOperation) {
        var optionsCopy = options ?? [:]
        optionsCopy["pair"] = pairs.joined(separator: ",")
        request.getRequest(with: "Depth", params:optionsCopy, completion:completion)
    }
    
    public func trades(pairs: [String], options: [String:String]? = nil, completion: @escaping Network.AsyncOperation) {
        var optionsCopy = options ?? [:]
        optionsCopy["pair"] = pairs.joined(separator: ",")
        request.getRequest(with: "Trades", params:optionsCopy, completion:completion)
    }
    
    public func spread(pairs: [String], options: [String:String]? = nil, completion: @escaping Network.AsyncOperation) {
        var optionsCopy = options ?? [:]
        optionsCopy["pair"] = pairs.joined(separator: ",")
        request.getRequest(with: "Spread", params:optionsCopy, completion:completion)
    }
    
    // MARK: Private methods
    
    public func balance(options: [String:String]? = nil, completion: @escaping Network.AsyncOperation) {
        request.postRequest(with: "Balance", params: options, completion: completion)
    }
    
    public func tradeBalance(options: [String:String]? = nil, completion: @escaping Network.AsyncOperation) {
        request.postRequest(with: "TradeBalance", params: options, completion: completion)
    }
    
    public func openOrders(options: [String:String]? = nil, completion: @escaping Network.AsyncOperation) {
        request.postRequest(with: "OpenOrders", params: options, completion: completion)
    }
    
    public func queryOrders(options: [String:String]? = nil, completion: @escaping Network.AsyncOperation) {
        request.postRequest(with: "QueryOrders", params: options, completion: completion)
    }
    
    public func tradesHistory(options: [String:String]? = nil, completion: @escaping Network.AsyncOperation) {
        request.postRequest(with: "TradesHistory", params: options, completion: completion)
    }
    
    public func queryTrades(ids: [String], options: [String:String]? = nil, completion: @escaping Network.AsyncOperation) {
        var optionsCopy = options ?? [:]
        optionsCopy["txid"] = ids.joined(separator: ",")
        request.postRequest(with: "QueryTrades", params: optionsCopy, completion: completion)
    }
    
    public func openPositions(ids: [String], options: [String:String]? = nil, completion: @escaping Network.AsyncOperation) {
        var optionsCopy = options ?? [:]
        optionsCopy["txid"] = ids.joined(separator: ",")
        request.postRequest(with: "OpenPositions", params: optionsCopy, completion: completion)
    }
    
    public func ledgersInfo(options: [String:String]? = nil, completion: @escaping Network.AsyncOperation) {
        request.postRequest(with: "Ledgers", params: options, completion: completion)
    }
    
    public func queryLedgers(ledgerIds: [String], options: [String:String]? = nil, completion: @escaping Network.AsyncOperation) {
        var optionsCopy = options ?? [:]
        optionsCopy["id"] = ledgerIds.joined(separator: ",")
        request.postRequest(with: "QueryLedgers", params: optionsCopy, completion: completion)
    }
    
    public func tradeVolume(pairs: [String], options: [String:String]? = nil, completion: @escaping Network.AsyncOperation) {
        var optionsCopy = options ?? [:]
        optionsCopy["pair"] = pairs.joined(separator: ",")
        request.postRequest(with: "TradeVolume", params: optionsCopy, completion: completion)
    }
    
    public func addOrder(options: [String:String], completion: @escaping Network.AsyncOperation) {
        let valuesNeeded = ["pair", "type", "orderType", "volume"]
        guard options.keys.contains(array: valuesNeeded) else {
            fatalError("Required options, not given. Input must include \(valuesNeeded)")
        }
        request.postRequest(with: "AddOrder", params: options, completion: completion)
    }
    
    public func cancelOrder(ids: [String], completion: @escaping Network.AsyncOperation) {
        var optionsCopy: [String:String] = [:]
        optionsCopy["txid"] = ids.joined(separator: ",")
        request.postRequest(with: "CancelOrder", params: optionsCopy, completion: completion)
    }
    
}
