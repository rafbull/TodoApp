//
//  NetworkService.swift
//  ToDoApp
//
//  Created by Rafis on 11.07.2024.
//

import Foundation

protocol NetworkServiceProtocol {
    func startTask()
    func cancelTask()
}

final class NetworkService: NetworkServiceProtocol {
    var tasks = [Task<Void, Never>]()

    func startTask() {
        guard let url = URL(string: "https://link.testfile.org/15MB")
        else { return }

        let request = URLRequest(url: url)

        let task = Task {
            do {
                _ = try await URLSession.shared.dataTask(for: request)
                print("✅ >>> TASK FINISHED")
            } catch {
                print("❌ >>> TASK CANCELED Error: \(error.localizedDescription)")
            }
        }

        tasks.append(task)
    }

    func cancelTask() {
        guard !tasks.isEmpty else { return }
        DispatchQueue.global().async { [weak self] in
            let removedTask = self?.tasks.removeLast()
            removedTask?.cancel()
        }
    }
}
