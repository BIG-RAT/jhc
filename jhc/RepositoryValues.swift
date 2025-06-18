//
//  Copyright 2025, Jamf
//

import Foundation
import OSLog

struct AppInfo {
    static let bundleId      = Bundle.main.bundleIdentifier!
    static let dict          = Bundle.main.infoDictionary!
    static let version       = dict["CFBundleShortVersionString"] as! String
    static let build         = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    static let name          = dict["CFBundleExecutable"] as! String
    static let displayname   = dict["CFBundleDisplayName"] as! String
    
    static let appSupport    = NSHomeDirectory() + "/Library/Application Support/"

    static let userAgentHeader = "\(bundleId)/\(AppInfo.version)"
}

class RepositoryValues {

    struct URLList: Codable {
        let urls: [String: String]
    }

    func url(for key: String) -> URL? {
        guard let url = Bundle.main.url(forResource: "urls", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            Logger.resourceCheck.info("failed to locate or read urls.json in the app bundle.")
            return nil
        }

        do {
            let urlList = try JSONDecoder().decode(URLList.self, from: data)
            if let urlString = urlList.urls[key] {
                return URL(string: urlString)
            } else {
                Logger.resourceCheck.info("key '\(key)' not found.")
                return nil
            }
        } catch {
            Logger.resourceCheck.info("failed to decode: \(error)")
            return nil
        }
    }
}
