//  Zerion.swift
//
//
//  Created by linshizai on 2022/6/13.
//

import SocketIO
import Foundation

public final class ZerionClient {

    private let url = "wss://api-v4.zerion.io"
    private let apiKey = "Demo.ukEVQp6L5vfgxcz4sBke7XvS873GMYHy"

    private lazy var socketManager: SocketManager = {
        return  SocketManager(
            socketURL: URL(string: url)!,
            config: [
                .log(false),
                .forceWebsockets(true),
                .version(.two),
                .secure(true)
            ]
        )
    }()

    public init() {}

    public func connect(namespace: EventNamespace) {
        let socketClient = socketManager.socket(forNamespace: namespace.rawValue)

        socketClient.on(clientEvent: .connect) { [weak self] data, ack in
            guard let self = self else { return }
        }

        socketClient.on(clientEvent: .disconnect) { [weak self] data, ack in
            guard let self = self else { return }
        }

        socketClient.on(clientEvent: .error) { [weak self] data, ack in
            guard let self = self else { return }
        }

        socketClient.connect(withPayload: ["api_token": apiKey])
    }

    public func disconnect(namespace: EventNamespace) {
        socketManager.disconnectSocket(forNamespace: namespace.rawValue)
    }

    public func send(_ event: Event) {
        let socketClient = socketManager.socket(forNamespace: event.namespace.rawValue)
        let subscriptionID = UUID()
        let item = SocketIODataItem(id: subscriptionID, scope: event.scope, payload: event.payload)
        socketClient.emit(event.action.rawValue, item)
    }

    public func subscribe<T: Decodable>(_ event: Event, type: T.Type) {
        let socketClient = socketManager.socket(forNamespace: event.namespace.rawValue)
        socketClient.on(event.keyPath) { data, ack in
            do {
//                let data: T = try event.decode(data: data)
            } catch {
            }
        }
    }

    public func unsubscribe(_ event: Event) {
        let socketClient = socketManager.socket(forNamespace: event.namespace.rawValue)
        socketClient.off(event.keyPath)
    }
}
