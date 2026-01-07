//
//  Copyright 2025 Jamf. All rights reserved.
//

import Cocoa
import Foundation

let defaults   = UserDefaults.standard

struct AppInfo {
    static let bundleId      = Bundle.main.bundleIdentifier!
    static let dict          = Bundle.main.infoDictionary!
    static let version       = dict["CFBundleShortVersionString"] as? String ?? "0.0.0"
    static let build         = Bundle.main.infoDictionary!["CFBundleVersion"] as? String ?? ""
    static let name          = dict["CFBundleExecutable"] as? String ?? ""
    static let displayname   = dict["CFBundleDisplayName"] as? String ?? ""
    
    static let appSupport    = NSHomeDirectory() + "/Library/Application Support/"
}
