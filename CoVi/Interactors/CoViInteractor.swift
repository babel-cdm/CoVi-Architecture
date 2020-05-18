//
//  CoViInteractor.swift
//  CoVi
//
//  Created by Jorge Guilabert Ibáñez on 09/09/2019.
//  Copyright © 2019 Babel SI. All rights reserved.
//

import Foundation

/**
 CoVi base interactor.

 # Generic Parameters
 - Input: Input parameter. It there is no parameter, type Void.
 - Output: Output parameter. It there is no parameter, type Void.
 - Process: Process parameter. It there is no parameter, type Void. It is used for example if you want to know the process of an image upload.
 */
open class CoViInteractor<Input, Output, Process>: CoViDisposable {

    // MARK: - Properties

    private var isStopped: Bool = false
    private var onCompletionStopped: (() -> Void)?

    private var coviDisposeBag: CoViDisposeBag?

    /**
     Thread where the `handle(_:_:_:_:)` function will be executed.
     This variable can be overridden to change the dispatch queue.
     By default, the dispatchQueue is 'DispatchQueue.global(qos: .background)'
     */
    open var dispatchQueue: DispatchQueue {
        return DispatchQueue.global(qos: .background)
    }

    // MARK: - Initializer

    /// Initializer that adds an observer to know when the `deinit` of the presenter is called, to de-initialize the interactor.
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

    /**
     Main method of executing the interactor.
     This method executes the `handle(_:_:_:_:)` method on the thread that has been indicated in the `dispatchQueue` variable.

     - Parameters:
        - parameter: The only parameter where it will have all the necessary properties to execute the interactor.
        - onSuccess: Called when the interactor has been successfully completed.
        - onFailure: Called in when the interactor has mistakenly ended.
        - onProcess: It is only called if the `handle(_:_:_:_:)` method is used, passing it to some process to know the progress. For example in an image upload.
        - onStopped: Called when the interactor has stopped calling the `dispose(_:)`, or has been released from memory.

     - Returns: Disposable object in case the programmer wants to release the interactor before the end of the use case.
     */
    public func execute(_ parameter: Input? = nil,
                        onSuccess: ((Output) -> Void)? = nil,
                        onFailure: ((Error) -> Void)? = nil,
                        onProcess: ((Process) -> Void)? = nil,
                        onStopped: (() -> Void)? = nil) -> CoViDisposable {
        return executeInteractor(parameter, onSuccess: onSuccess, onFailure: onFailure, onProcess: onProcess, onStopped: onStopped)
    }

    /**
     Method required to ensure that the interactor does not remain in memory.
     In this function, a disposeBag is assigned to know when the object is deinitialized, to relase the interactor from memory.

     - Parameter bag: DisposeBag to know when to relase from memory.
     */
    public func disposed(by bag: CoViDisposeBag) {
        self.coviDisposeBag = bag
    }

    /// Method to release the interactor from memory and thus stop the process, even if it is unfinished.
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

    /**
     This function must be overridden to add code that we want to execute the use case in the thread indicated in the `dispatchQueue` variable.
     Use this function when the Interactor has an Input and an Output other than 'Void'.

     - Parameters:
        - parameter: Input parameter entered in the `execute(_:_:_:_:_:)` method.
        - onSuccess: Success completion handler with Output object.
        - onFailure: Failure completion handler with Error object.
        - onProcess: Process completion handler with Process object.
     */
    open func handle(parameter: Input,
                     onSuccess: @escaping (Output) -> Void,
                     onFailure: @escaping (Error) -> Void,
                     onProcess: @escaping (Process) -> Void) {
        if let onSuccessCompletion = getVoidCompletion(onSuccess) {
            handle(parameter: parameter, onSuccess: onSuccessCompletion, onFailure: onFailure, onProcess: onProcess)
        }
    }

    /**
     This function must be overridden to add code that we want to execute the use case in the thread indicated in the `dispatchQueue` variable.
     Use this function when the Interactor has Output object only other than 'Void'.

     - Parameters:
        - onSuccess: Success completion handler with Output object.
        - onFailure: Failure completion handler with Error object.
        - onProcess: Process completion handler with Process object.
     */
    open func handle(onSuccess: @escaping (Output) -> Void,
                     onFailure: @escaping (Error) -> Void,
                     onProcess: @escaping (Process) -> Void) {
        if let onSuccessCompletion = getVoidCompletion(onSuccess) {
            handle(onSuccess: onSuccessCompletion, onFailure: onFailure, onProcess: onProcess)
        }
    }

    /**
     This function must be overridden to add code that we want to execute the use case in the thread indicated in the `dispatchQueue` variable.
     Use this function when the Interactor has an Input other than 'Void', but the Output is 'Void' type.

     - Parameters:
        - parameter: Success completion handler with Output object.
        - onSuccess: Success completion handler without object.
        - onFailure: Failure completion handler with Error object.
        - onProcess: Process completion handler with Process object.
     */
    open func handle(parameter: Input,
                     onSuccess: @escaping () -> Void,
                     onFailure: @escaping (Error) -> Void,
                     onProcess: @escaping (Process) -> Void) {}

    /**
     This function must be overridden to add code that we want to execute the use case in the thread indicated in the `dispatchQueue` variable.
     Use this function when the Interactor has neither Input nor Output. That is, both are 'Void' type.

     - Parameters:
        - onSuccess: Success completion handler without object.
        - onFailure: Failure completion handler with Error object.
        - onProcess: Process completion handler with Process object.
     */
    open func handle(onSuccess: @escaping () -> Void,
                     onFailure: @escaping (Error) -> Void,
                     onProcess: @escaping (Process) -> Void) {}

}
