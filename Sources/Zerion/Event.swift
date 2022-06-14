//
//  Event.swift
//  
//
//  Created by linshizai on 2022/6/14.
//

import Foundation
import SocketIO

extension Data {
    public func parse<T: Decodable>(type: T.Type) -> Result<T, Error> {
        return Result {
            return try JSONDecoder().decode(T.self, from: self)
        }
    }
}

enum EventNamespace: String {
    case address = "/address"
    case `default` = "/"
}

struct SocketIODataItem: Codable, SocketData {
    let id: UUID
    let scope: String
    let payload: [String: String]

    func socketRepresentation() -> SocketData {
        return [
            "id": id.uuidString,
            "scope": [scope],
            "payload": payload
        ]
    }
}

public enum Event {
    case positions(address: String)

    var scope: String {
        switch self {
        case .positions: return "positions"
        }
    }

    var payload: [String: String] {
        switch self {
        case .positions(let address):
            return ["address": address]
        }
    }

    var action: Action {
        switch self {
        case .positions(_):
            return .get
        }
    }

    enum Action: String {
        case get, subscribe, unsubscribe
    }

    var namespace: EventNamespace {
        switch self {
        case .positions(_):
            return .address
        }
    }

    // For subscribe or unsubscribe event
    var keyPath: String {
        switch self {
        case .positions:
            return "received address \(scope)"
        }
    }

//    func decode<T: Decodable>(data: [Any]) throws -> T {
//        guard let dic = data.first as? [String: [String: Any]] else {
//            throw Web3Error.wrongJsonFromat(nil)
//        }
//
//        switch self {
//        case .positions(_):
//            guard let dic = dic["payload"]?["positions"],
//                  let dic = dic as? [String: Any],
//                  let array = dic["positions"] as? [Any] else {
//                throw Web3Error.wrongJsonFromat(nil)
//            }
//            do {
//                let jsonData = try JSONSerialization.data(withJSONObject: array)
//                let objects = try JSONDecoder().decode(T.self, from: jsonData)
//                return objects
//            } catch {
//                throw Web3Error.wrongJsonFromat(error)
//            }
//        }
//    }
}
