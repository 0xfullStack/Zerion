//
//  Models.swift
//  
//
//  Created by linshizai on 2022/6/13.
//

import Foundation

public struct Response: Decodable {
    public let meta: Meta
    public let payload: Payload
}

public struct Meta: Codable {
    public let status: String
    public let address: String?
    public let transactionsOffset: Int
    public let addresses: [String]
    public let transactionsLimit: Int
    public let currency: String
}

public struct Payload: Decodable {
    public let transactions: [Transaction]
}

public struct Position: Decodable {
    public let chain: String
    public let asset: Asset

    public struct Asset: Decodable {
        public let price: PriceInfo?
        public let implementations: [String: Detail]

        public struct Detail: Decodable {
            public let address: String?
            public let decimals: Double
        }

        public struct PriceInfo: Decodable {
            public let value: Double
            public let relativeChange24h: Double?

            enum CodingKeys: String, CodingKey {
                case value
                case relativeChange24h = "relative_change_24h"
            }
        }
    }
}

public struct Transaction: Decodable {
    public let txHash: String
    public let addressFrom: String
    public let addressTo: String?
    public let `protocol`: String?
    public let blockNumber: Int
    public let contract: String?
    public let direction: Direction?
    public let id: String
    public let minedAt: Int
    public let nonce: Int?
    public let changes: [TransactionChange]?
    public let fee: Fee?
    public let txType: String
    public let status: String
    
    enum CodingKeys: String, CodingKey {
        case txHash = "hash"
        case addressFrom
        case addressTo
        case `protocol`
        case blockNumber
        case contract
        case direction
        case id
        case minedAt
        case nonce
        case changes
        case fee
        case txType = "type"
        case status
    }
}

public struct TransactionChange: Decodable {
    public let price: Double?
    public let addressFrom: String
    public let addressTo: String
    public let value: Double
    public let direction: Direction
    public let asset: ChangeAsset
//        public let nftAsset: NftAsset? // Need to fix decoding issue
}

public enum Direction: String, Decodable {
    case `in`
    case out
    case `self`
}

public struct ChangeAsset: Decodable {
    public let assetCode: String
    public let symbol: String
    public let isVerified: Bool
    public let id: String
    public let decimals: Int
    public let price: ChangeAssetPrice?
    public let iconURL: String?
    public let isDisplayable: Bool
    public let type: String?
    public let name: String
    public let implementations: Implementations
}

public struct ChangeAssetPrice: Decodable {
    public let value: Double
    public let relativeChange24h: Double?
    public let changedAt: Int
}

public struct Implementations: Decodable {
    public let ethereum: Ethereum?
}

public struct Ethereum: Decodable {
    public let address: String?
    public let decimals: Int
}

public struct NftAsset: Decodable {
    public let collection: NftCollection?
    public let relevantUrls: [RelevantURL]
    public let description: String
    public let attributes: [NftAttribute]
    public let asset: NftAssetAsset
}

public struct NftAttribute: Decodable {
    public let key: String
    public let value: String
}

public struct NftAssetAsset: Decodable {
    public let detail, preview: Detail
    public let isVerified: Bool
    public let floorPrice: Double
    public let symbol: String
    public let lastPrice: Double?
    public let tokenId: String
    public let contractAddress: String
    public let type: String
    public let interface: String
    public let assetCode: String
    public let isDisplayable: Bool
    public let name: String
    public let collection: NftCollection
}

public struct NftCollection: Decodable {
    public let name: String
    public let iconUrl: String
    public let description: String
}

public struct Detail: Decodable {
    public let url: String
}

public struct RelevantURL: Decodable {
    public let name: String
    public let url: String
}

public struct Fee: Decodable {
    public let value: Int
    public let price: Double
}
