//
//  CoViInteractor.swift
//  CoVi
//
//  Created by Jorge Guilabert Ibáñez on 09/09/2019.
//  Copyright © 2019 Babel SI. All rights reserved.
//

import Foundation

public protocol CoViInteractorProtocol: CoViDisposable {
    associatedtype Output
    func execute(onSuccess: ((Output) -> Void)?,
                 onFailure: ((Error) -> Void)?,
                 onStopped: (() -> Void)?) -> CoViDisposable
    func execute(_ parameter: CoViInteractorParameterProtocol,
                 onSuccess: ((Output) -> Void)?,
                 onFailure: ((Error) -> Void)?,
                 onStopped: (() -> Void)?) -> CoViDisposable
}

public protocol CoViInteractorParameterProtocol: class {}

open class CoViInteractor<Output>: CoViInteractorProtocol {

    // MARK: - Properties

    private var isStopped: Bool = false
    private var onCompletionStopped: (() -> Void)?

    private var coviDisposeBag: CoViDisposeBag?

    // MARK: - Initializer

    public init() {
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(disposeBagValueDisposed),
                         name: disposeBagNotificationId,
                         object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: disposeBagNotificationId, object: nil)
    }

    // MARK: - Functions

    public func execute(onSuccess: ((Output) -> Void)?,
                        onFailure: ((Error) -> Void)?,
                        onStopped: (() -> Void)?) -> CoViDisposable {
        return executeInteractor(nil, onSuccess: onSuccess, onFailure: onFailure, onStopped: onStopped)
    }

    public func execute(_ parameter: CoViInteractorParameterProtocol,
                        onSuccess: ((Output) -> Void)?,
                        onFailure: ((Error) -> Void)?,
                        onStopped: (() -> Void)?) -> CoViDisposable {
        return executeInteractor(parameter, onSuccess: onSuccess, onFailure: onFailure, onStopped: onStopped)
    }

    public func disposed(by bag: CoViDisposeBag) {
        self.coviDisposeBag = bag
    }

    open func dispose() {
        if let onStopped = onCompletionStopped, !isStopped {
            onStopped()
        }
        onCompletionStopped = nil
        isStopped = true
        coviDisposeBag = nil
    }

    private func executeInteractor(_ parameter: CoViInteractorParameterProtocol?,
                                   onSuccess: ((Output) -> Void)?,
                                   onFailure: ((Error) -> Void)?,
                                   onStopped: (() -> Void)?) -> CoViDisposable {
        isStopped = false
        onCompletionStopped = onStopped

        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let strongSelf = self else {
                return
            }

            strongSelf.handle(parameter: parameter,
                              onSuccess: strongSelf.onCompletion(onSuccess),
                              onFailure: strongSelf.onCompletion(onFailure))
        }

        return self
    }

    private func onCompletion<T>(_ onCompletion: ((T) -> Void)?) -> ((T) -> Void) {
        return { [weak self] object in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else {
                    return
                }

                if let onCompletion = onCompletion,
                    !strongSelf.isStopped,
                    strongSelf.coviDisposeBag != nil {
                    onCompletion(object)
                }
            }
        }
    }

    @objc private func disposeBagValueDisposed(_ notification: Notification) {
        if let userInfo = notification.userInfo as? [String: Any],
            let bag = userInfo[disposeBagNotificationParameter] as? CoViDisposeBag {
            if bag === coviDisposeBag {
                dispose()
            }
        }
    }

    open func handle(parameter: CoViInteractorParameterProtocol?,
                     onSuccess: @escaping (Output) -> Void,
                     onFailure: @escaping (Error) -> Void) {}

}
