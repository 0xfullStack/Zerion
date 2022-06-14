//  Zerion.swift
//
//
//  Created by linshizai on 2022/6/13.
//

import SocketIO
import Foundation
import RxSwift
import ReactiveX

public final class Zerion {
    
    public static let shared = Zerion()
    public var connectStatus: Observable<Bool> {
        proxy.rx.connected.share()
    }

    private let url = "wss://api-v4.zerion.io"
    private let apiKey = "Demo.ukEVQp6L5vfgxcz4sBke7XvS873GMYHy"
    private let bag = DisposeBag()
    private lazy var mannager: SocketManager = {
        return SocketManager(socketURL: URL(string: url)!, config: [
            .log(false), .forceWebsockets(true),
            .version(.two), .secure(true)
        ])
    }()
    
    private lazy var proxy: SocketIOProxy = {
        return SocketIOProxy(
            manager: mannager,
            namespace: EventNamespace.address.rawValue,
            payload: ["api_token": apiKey]
        )
    }()

    public init() {
        
        subscribeReachability()
        
    }
    
    private func subscribeReachability() {
        
    }
    
    public func on(_ event: Event) -> Observable<[Any]> {
        connectStatus
            .filter { $0 }
            .flatMapLatest { [weak self] connected -> Observable<Void> in
                guard let self = self else { return .never() }
                return self.proxy.rx.emit(
                    event.action.rawValue,
                    SocketIODataItem(id: UUID(), scope: event.scope, payload: event.payload)
                )
            }
            .observe(on: MainScheduler.asyncInstance)
            .flatMapLatest { [weak self] _ -> Observable<[Any]> in
                guard let self = self else { return .never() }
                return self.proxy.rx.on(event.keyPath).map { $0.0 }
            }
    }
    
    public func off(_ event: Event) -> Observable<Void> {
        fatalError("Not implemented!!")
    }
}
//
//extension Zerion {
//    func on<T: Decodable>(event: Event) -> Observable<T> {
//        return Observable.create { [weak self] observer in
//            guard let self = self else {
//                return Disposables.create()
//            }
//            self.socketManager
//                .socket(forNamespace: event.namespace.rawValue)
//                .on(event.keyPath) { data , ack in
//                    guard let dic = data.first as? [String: [String: Any]] else {
//                        return
//                    }
//
//                    switch event {
//                    case .positions(_):
//                        guard let dic = dic["payload"]?["positions"],
//                              let dic = dic as? [String: Any],
//                              let array = dic["positions"] as? [Any] else {
//                            return
//                        }
//                        do {
//                            let jsonData = try JSONSerialization.data(withJSONObject: array)
//                            let objects = try JSONDecoder().decode(T.self, from: jsonData)
//                            observer.onNext(objects)
//                        } catch {
//                            return
//                        }
//                    }
//                }
//            return Disposables.create()
//        }
//    }
//}
