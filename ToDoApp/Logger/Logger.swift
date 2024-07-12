//
//  Logger.swift
//  ToDoApp
//
//  Created by Rafis on 10.07.2024.
//

import Foundation
import CocoaLumberjackSwift

final class Logger {
    static func setupLogger() {
        if let ddtyLogger = DDTTYLogger.sharedInstance {
            DDLog.add(ddtyLogger)
        }
        DDLog.add(DDOSLogger.sharedInstance)

        let fileLogger: DDFileLogger = DDFileLogger()
        fileLogger.rollingFrequency = TimeInterval(60*60*48)
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
    }
}
