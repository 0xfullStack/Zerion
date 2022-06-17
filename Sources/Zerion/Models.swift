//
//  Models.swift
//  
//
//  Created by linshizai on 2022/6/13.
//

import Foundation

public extension Zerion {
    struct Response: Decodable {
        public let meta: Meta
        public let payload: Payload
    }

    struct Meta: Codable {
        public let status: String
        public let address: String?
        public let transactionsOffset: Int
        public let addresses: [String]
        public let transactionsLimit: Int
        public let currency: String
    }

    struct Payload: Decodable {
        public let transactions: [Transaction]
    }

    struct Position: Decodable {
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

    struct Transaction: Decodable {
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

    struct TransactionChange: Decodable {
        public let price: Double?
        public let addressFrom: String
        public let addressTo: String
        public let value: Double
        public let direction: Direction
        public let asset: ChangeAsset
    //        public let nftAsset: NftAsset? // Need to fix decoding issue
    }

    enum Direction: String, Decodable {
        case `in`
        case out
        case `self`
    }

    struct ChangeAsset: Decodable {
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

    struct ChangeAssetPrice: Decodable {
        public let value: Double
        public let relativeChange24h: Double?
        public let changedAt: Int
    }

    struct Implementations: Decodable {
        public let ethereum: Ethereum?
    }

    struct Ethereum: Decodable {
        public let address: String?
        public let decimals: Int
    }

    struct NftAsset: Decodable {
        public let collection: NftCollection?
        public let relevantUrls: [RelevantURL]
        public let description: String
        public let attributes: [NftAttribute]
        public let asset: NftAssetAsset
    }

    struct NftAttribute: Decodable {
        public let key: String
        public let value: String
    }

    struct NftAssetAsset: Decodable {
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

    struct NftCollection: Decodable {
        public let name: String
        public let iconUrl: String
        public let description: String
    }

    struct Detail: Decodable {
        public let url: String
    }

    struct RelevantURL: Decodable {
        public let name: String
        public let url: String
    }

    struct Fee: Decodable {
        public let value: Int
        public let price: Double
    }

}
