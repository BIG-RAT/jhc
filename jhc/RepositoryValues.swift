//
//  Copyright 2026, Jamf
//

import Foundation
import OSLog

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
