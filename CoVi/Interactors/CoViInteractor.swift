//
//  CoViInteractor.swift
//  CoVi
//
//  Created by Jorge Guilabert Ibáñez on 09/09/2019.
//  Copyright © 2019 Babel SI. All rights reserved.
//

import Foundation

open class CoViInteractor<Input, Output, Process>: CoViDisposable {

    // MARK: - Properties

    private var isStopped: Bool = false
    private var onCompletionStopped: (() -> Void)?

    private var coviDisposeBag: CoViDisposeBag?

    open var dispatchQueue: DispatchQueue {
        return DispatchQueue.global(qos: .background)
    }

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

    public func execute(_ parameter: Input? = nil,
                        onSuccess: ((Output) -> Void)? = nil,
                        onFailure: ((Error) -> Void)? = nil,
                        onProcess: ((Process) -> Void)? = nil,
                        onStopped: (() -> Void)? = nil) -> CoViDisposable {
        return executeInteractor(parameter, onSuccess: onSuccess, onFailure: onFailure, onProcess: onProcess, onStopped: onStopped)
    }

    public func disposed(by bag: CoViDisposeBag) {
        self.coviDisposeBag = bag
    }

    public func dispose() {
        if let onStopped = onCompletionStopped, !isStopped {
            onStopped()
        }
        onCompletionStopped = nil
        isStopped = true
        coviDisposeBag = nil
    }

    private func executeInteractor(_ parameter: Input?,
                                   onSuccess: ((Output) -> Void)?,
                                   onFailure: ((Error) -> Void)?,
                                   onProcess: ((Process) -> Void)?,
                                   onStopped: (() -> Void)?) -> CoViDisposable {
        isStopped = false
        onCompletionStopped = onStopped

        dispatchQueue.async { [weak self] in
            guard let strongSelf = self else {
                return
            }

            let onSuccessCompletion = strongSelf.onCompletion(onSuccess)
            let onFailureCompletion = strongSelf.onCompletion(onFailure)
            let onProcessCompletion = strongSelf.onCompletion(onProcess)

            if let parameter = parameter, Input.self != Void.self {
                strongSelf.handle(parameter: parameter,
                                  onSuccess: onSuccessCompletion,
                                  onFailure: onFailureCompletion,
                                  onProcess: onProcessCompletion)
            } else {
                strongSelf.handle(onSuccess: onSuccessCompletion,
                                  onFailure: onFailureCompletion,
                                  onProcess: onProcessCompletion)
            }
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

    private func getVoidCompletion<T>(_ onCompletion: @escaping (T) -> Void) -> (() -> Void)? {
        if let onVoidCompletion = onCompletion as? ((()) -> Void) {
            return { onVoidCompletion(()) }
        }
        return nil
    }

    @objc private func disposeBagValueDisposed(_ notification: Notification) {
        if let userInfo = notification.userInfo as? [String: Any],
            let bag = userInfo[disposeBagNotificationParameter] as? CoViDisposeBag {
            if bag === coviDisposeBag {
                dispose()
            }
        }
    }

    open func handle(parameter: Input,
                     onSuccess: @escaping (Output) -> Void,
                     onFailure: @escaping (Error) -> Void,
                     onProcess: @escaping (Process) -> Void) {
        if let onSuccessCompletion = getVoidCompletion(onSuccess) {
            handle(parameter: parameter, onSuccess: onSuccessCompletion, onFailure: onFailure, onProcess: onProcess)
        }
    }

    open func handle(onSuccess: @escaping (Output) -> Void,
                     onFailure: @escaping (Error) -> Void,
                     onProcess: @escaping (Process) -> Void) {
        if let onSuccessCompletion = getVoidCompletion(onSuccess) {
            handle(onSuccess: onSuccessCompletion, onFailure: onFailure, onProcess: onProcess)
        }
    }

    open func handle(parameter: Input,
                     onSuccess: @escaping () -> Void,
                     onFailure: @escaping (Error) -> Void,
                     onProcess: @escaping (Process) -> Void) {}

    open func handle(onSuccess: @escaping () -> Void,
                     onFailure: @escaping (Error) -> Void,
                     onProcess: @escaping (Process) -> Void) {}

}
