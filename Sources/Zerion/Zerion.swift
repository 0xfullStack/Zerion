//  Zerion.swift
//
//
//  Created by linshizai on 2022/6/13.
//

import SocketIO
import Foundation
import RxSwift
import ReactiveX
import Reachability
import UIKit

public final class Zerion {
    
    public static let shared = Zerion()
    public var connectStatus: Observable<Bool> {
        proxy.rx.connected.share()
    }

    private let url = "wss://api-v4.zerion.io"
    private let apiKey = "Demo.ukEVQp6L5vfgxcz4sBke7XvS873GMYHy"
    private var reachabilityBag = DisposeBag()
    private lazy var reachability: Reachability? = {
        Reachability()
    }()
    private lazy var reachabilitySignal: Observable<Bool> = {
        reachability?.rx.isReachable ?? .never()
    }()
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

    public init() {}
    
    private func subscribeReachability() {
        releaseBag()
        let reachable = reachabilitySignal.filter { $0 }.startWith(true).map { _ in () }
        let enterForeground = UIApplication.rx.willEnterForeground.asObservable().startWith(())
        Observable
            .combineLatest(connectStatus, reachable, enterForeground)
            .subscribe(onNext: { [weak self] (connectStatus, reachable, enterForeground) in
                guard let self = self else { return }
                guard !connectStatus else { return }
                self.proxy.connectIfNeed()
            })
            .disposed(by: reachabilityBag)
    }
    
    private func releaseBag() {
        reachabilityBag = DisposeBag()
    }
    
    public func subscribe(_ event: Event) -> Observable<[Any]> {
        connectStatus
            .filter { $0 }
            .flatMapLatest { [weak self] connected -> Observable<Void> in
                guard let self = self else { return .never() }
                return self.proxy.rx.emit(
                    Event.Action.subscribe.rawValue,
                    SocketIODataItem(id: UUID(), scope: event.scope, payload: event.payload)
                )
            }
            .observe(on: MainScheduler.asyncInstance)
            .flatMapLatest { [weak self] _ -> Observable<[Any]> in
                guard let self = self else { return .never() }
                return self.proxy.rx.on(event.keyPath).map { $0.0 }
            }
    }
    
    public func unsubscribe(_ event: Event) -> Observable<Void> {
        connectStatus
            .filter { $0 }
            .flatMapLatest { [weak self] connected -> Observable<Void> in
                guard let self = self else { return .never() }
                return self.proxy.rx.emit(
                    Event.Action.unsubscribe.rawValue,
                    SocketIODataItem(id: UUID(), scope: event.scope, payload: event.payload)
                )
            }
    }
    
    public func disconnect() {
        reachabilityBag = DisposeBag()
        proxy.disconnected()
    }
    
    public func connect() {
        reachabilityBag = DisposeBag()
        proxy.connectIfNeed()
    }
}
