//
//  LoggerManager.swift
//  VideoFeedTask
//
//  Created by DIGITAL VENTURES on 07/02/2026.
//

import os
import SwiftUI

/// A class to manage logging functionality
struct LoggerManager {
    /// Shared static instance for singleton access
    static let shared = LoggerManager(subsystem: "com.laidstall.VideoFeedTask", category: "App")

    /// Private logger instance
    private let logger: Logger

    /// Private initializer to prevent external initialization
    private init(subsystem: String, category: String) {
        logger = Logger(subsystem: subsystem, category: category)
    }

    /// Log an informational message (only in debug mode)
    func logInfo(_ message: String) {
        #if DEBUG || STAGING
            logger.log(level: .info, "\(message)")
        #endif
    }

    /// Log a debug message (only in debug mode)
    func logDebug(_ message: String) {
        #if DEBUG || STAGING
            logger.log(level: .debug, "\(message)")
        #endif
    }

    /// Log a warning message (only in debug mode)
    func logWarning(_ message: String) {
        #if DEBUG || STAGING
            logger.log(level: .error, "\(message)")
        #endif
    }

    /// Log an error message (only in debug mode)
    func logError(_ message: String) {
        #if DEBUG || STAGING
            logger.log(level: .error, "\(message)")
        #endif
    }
}
