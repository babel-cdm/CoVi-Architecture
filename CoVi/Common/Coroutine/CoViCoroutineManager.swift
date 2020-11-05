//
//  CoViCoroutineManager.swift
//  CoVi
//
//  Created by Jorge Guilabert Ibáñez on 14/05/2020.
//  Copyright © 2020 Babel SI. All rights reserved.
//

import Foundation

public class CoViCoroutineManager {

    public typealias Producer<T> = (_ consumer: @escaping Consumer<T>) -> Void
    public typealias Consumer<T> = (_ object: T) -> Void

    public init() {}

    public func execute<T>(timeOutSeconds: Int? = nil, producer: @escaping Producer<T>) throws -> T {
        var result: T? = nil

        guard !Thread.isMainThread else {
            debugPrint("------- Error: CoViCoroutineManager executed on the Main Thread. -------")
            throw CoViCoroutineError.mainThread
        }

        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global(qos: .background).async {
            let consumer: Consumer<T> = { object in
                result = object
                semaphore.signal()
            }
            producer(consumer)
        }

        if let timeOutSeconds = timeOutSeconds {
            let timeOut = DispatchTime.now() + .seconds(timeOutSeconds)
            if semaphore.wait(timeout: timeOut) == .timedOut {
                debugPrint("------- Error: CoViCoroutineManager Timed Out. -------")
                throw CoViCoroutineError.timedOut
            }
        } else {
            semaphore.wait()
        }

        guard let finalResult = result else {
            throw CoViCoroutineError.unknown("------- Error: CoViCoroutineManager with Result NULL. -------")
        }

        return finalResult
    }

}

/*private class CoViBackgroudTask {
    init() {
        let coroutineManager = CoViCoroutineManager()

        // First way, returning opcional value:
        let _ = try? coroutineManager.execute(timeOutSeconds: 15) { (consumer: CoroutineManager.Consumer<String>) in
            consumer("")
        }

        // Second way, forcing cast:
        let _ = try! coroutineManager.execute { (consumer: CoroutineManager.Consumer<String>) in
            consumer("")
        }

        // Third way, doing try/catch:
        do {
            let _ = try coroutineManager.execute(timeOutSeconds: 5) { (consumer: CoroutineManager.Consumer<String>) in
                consumer("")
            }
        } catch CoViCoroutineError.mainThread {
            debugPrint("Main Thread Error")
        } catch CoViCoroutineError.timedOut {
            debugPrint("Timed Out Error")
        } catch CoViCoroutineError.unknown(let description) {
            debugPrint(description)
        } catch {
            debugPrint("ERROR")
        }
    }
}*/
