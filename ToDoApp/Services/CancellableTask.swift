//
//  CancellableTask.swift
//  ToDoApp
//
//  Created by Rafis on 16.07.2024.
//

import Foundation

final class CancellableTask {
    private let semaphore = DispatchSemaphore(value: 1)
    private var task: URLSessionDataTask?

    func add(_ task: URLSessionDataTask) {
        semaphore.wait()
        self.task = task
        semaphore.signal()
    }

    func cancel() {
        task?.cancel()
    }
}
