//
//  CoroutineManager.swift
//  CoVi
//
//  Created by Jorge Guilabert Ibáñez on 14/05/2020.
//  Copyright © 2020 Babel SI. All rights reserved.
//

import Foundation

public class CoroutineManager {

    public typealias Producer<T> = (_ consumer: Consumer<T>) -> Void
    public typealias Consumer<T> = (_ object: T) -> Void

    public init() {}

    public func execute<T>(timeOutSeconds: Int? = nil, producer: @escaping Producer<T>) throws -> T {
        var result: T? = nil

        guard !Thread.isMainThread else {
            debugPrint("------- Error: CoroutineManager executed on the Main Thread. -------")
            throw CoroutineError.mainThread
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
                debugPrint("------- Error: CoroutineManager Timed Out. -------")
                throw CoroutineError.timedOut
            }
        } else {
            semaphore.wait()
        }

        guard let finalResult = result else {
            throw CoroutineError.unknown("------- Error: CoroutineManager with Result NULL. -------")
        }

        return finalResult
    }

}

/*private class CoViBackgroudTask {
    init() {
        let coroutineManager = CoroutineManager()

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
        } catch CoroutineError.mainThread {
            debugPrint("Main Thread Error")
        } catch CoroutineError.timedOut {
            debugPrint("Timed Out Error")
        } catch CoroutineError.unknown(let description) {
            debugPrint(description)
        } catch {
            debugPrint("ERROR")
        }
    }
}*/
