//
//  Copyright 2026, Jamf
//

import Foundation
import OSLog

extension Logger {
    private static let subsystem = Bundle.main.bundleIdentifier!
    
    static let resourceCheck      = Logger(subsystem: subsystem, category: "resourceCheck")
    static let prohibitedVersions = Logger(subsystem: subsystem, category: "prohibitedVersions")
    static let versionCheck       = Logger(subsystem: subsystem, category: "versionCheck")
    static let alert              = Logger(subsystem: subsystem, category: "alert")
}
