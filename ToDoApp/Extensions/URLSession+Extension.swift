//
//  URLSession+Extension.swift
//  ToDoApp
//
//  Created by Rafis on 10.07.2024.
//

import Foundation
import CocoaLumberjackSwift

extension URLSession {
    func dataTask(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        var task: URLSessionDataTask?
        let semaphore = DispatchSemaphore(value: 1)
        let cancelTask = {
            semaphore.wait()
            task?.cancel()
            DDLogInfo("File: \(#fileID) Function: \(#function)\n\tCanceled task.")
            semaphore.signal()
        }
        
        return try await withTaskCancellationHandler {
            if Task.isCancelled {
                throw CancellationError()
            }
            return try await withCheckedThrowingContinuation { continuation in
                task = dataTask(with: urlRequest) { data, response, error in
                    
                    if Task.isCancelled {
                        return continuation.resume(throwing: CancellationError())
                    }
                    
                    if let error = error {
                        return continuation.resume(throwing: error)
                    }
                    
                    guard let data = data, let response = response
                    else {
                        return continuation.resume(throwing: URLError(.badServerResponse))
                    }
                    
                    if Task.isCancelled {
                        return continuation.resume(throwing: CancellationError())
                    }
                    
                    continuation.resume(returning: (data, response))
                }
                
                if Task.isCancelled {
                    cancelTask()
                    continuation.resume(throwing: CancellationError())
                    return
                }
                
                task?.resume()
            }
        } onCancel: {
            cancelTask()
        }
    }
}
