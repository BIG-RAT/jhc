//
//  Copyright 2026, Jamf
//

import Foundation
import OSLog

struct Version: Comparable {
    let major,
        minor,
        patch,
        beta: Int
    let isBeta: Bool
    
    init(_ version: String) {
        let (majorInit,
             minorInit,
             patchInit,
             isBetaInit,
             betaInit) = versionDetails(theVersion: version)
        self.major = majorInit
        self.minor = minorInit
        self.patch = patchInit
        self.isBeta = isBetaInit
        self.beta = betaInit
    }

    static func < (lhs: Version, rhs: Version) -> Bool {
        if lhs.major != rhs.major {
            return lhs.major < rhs.major
        }
        if lhs.minor != rhs.minor {
            return lhs.minor < rhs.minor
        }
        if lhs.patch != rhs.patch {
            return lhs.patch < rhs.patch
        }
        if lhs.isBeta && !rhs.isBeta {
            return true
        }
        if lhs.isBeta && rhs.isBeta {
            return lhs.beta < rhs.beta
        }
        return false
    }
}

private func versionDetails(theVersion: String) -> (Int, Int, Int, Bool, Int) {
    let versionArray = theVersion.split(separator: ".")
    guard versionArray.count >= 3,
          let major = Int(versionArray[0]),
          let minor = Int(versionArray[1]) else {
        return (0, 0, 0, false, 0)
    }

    let patchArray = versionArray[2].lowercased().split(separator: "b")
    guard let patch = Int(patchArray[0]) else {
        return (major, minor, 0, false, 0)
    }

    let isBeta = patchArray.count > 1
    let betaVer = isBeta ? Int(patchArray[1]) ?? 0 : 0

    return (major, minor, patch, isBeta, betaVer)
}



class ResourceCheck: NSObject, URLSessionDelegate {
    
    static let shared = ResourceCheck()
    
    @MainActor func launchCheck(prohibitedCheck: Bool = true, versionCheck: Bool = true) async {
        Logger.prohibitedVersions.debug("performing launch check")
        let prohibitedVersions = prohibitedCheck ? await ResourceCheck.shared.prohibited(): []
        let prohibited = prohibitedVersions.contains(AppInfo.version)
        
        let versionResult = await ResourceCheck.shared.version(forceCheck: versionCheck)
        
        if prohibited {
            Alert.shared.display(header: "", message: "This version, v\(AppInfo.version), is prohibited from running.")
            Logger.prohibitedVersions.info("this version, v\(AppInfo.version, privacy: .public), is prohibited from running. Application terminated.")
            if !versionResult.0 {
                exit(1)
            }
        }
        
        if versionResult.0 {
            Task {
                await Alert.shared.versionDialog(header: "Running API Utility: \(AppInfo.version)", version: versionResult.1, message: "A new version (\(versionResult.1)) is available.", updateAvail: versionResult.0)
                if prohibited {
                    exit(1)
                }
            }
        }
    }
    
    func prohibited() async -> [String] {
        
        let repositoryValues = RepositoryValues()
        var prohibitedVersion = [String]()
        
        URLCache.shared.removeAllCachedResponses()
                
        let configuration = URLSessionConfiguration.ephemeral
        guard let url = repositoryValues.url(for: "prohibited") else {
            Logger.prohibitedVersions.error("could not read URL for prohibited versions")
            return []
        }
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        configuration.httpAdditionalHeaders = ["Accept" : "application/json"]
        let session = URLSession(configuration: configuration)

        do {
            
            let checkResult = try await session.data(for: request)
            
            session.finishTasksAndInvalidate()
            if let httpResponse = checkResult.1 as? HTTPURLResponse {
                if (200...299).contains(httpResponse.statusCode) {
                    let json = try? JSONSerialization.jsonObject(with: checkResult.0, options: .allowFragments)
                    if let endpointJSON = json as? [String: Any] {
                        
                        prohibitedVersion = (endpointJSON["do_not_run_versions"] as? [String]) ?? []
                        Logger.prohibitedVersions.info("prohibited versions found: \(prohibitedVersion.description, privacy: .public)")

                        UserDefaults.standard.set(prohibitedVersion, forKey: "prohibitedVersions")
                    }
                } else {    // if httpResponse.statusCode <200 or >299
                    Logger.prohibitedVersions.info("prohibited response error: \(httpResponse.statusCode, privacy: .public)")
                    if let responseString = String(data: checkResult.0, encoding: .utf8) {
                        Logger.prohibitedVersions.debug("prohibitedVersions response: \(responseString, privacy: .public)")
                    } else {
                        Logger.prohibitedVersions.debug("prohibitedVersions: No response data returned")
                    }
                }
            }
        } catch {
            Logger.prohibitedVersions.debug("an unexpected error occurred: \(error.localizedDescription, privacy: .public)")
        }
        return prohibitedVersion
    }
    
    func version(forceCheck: Bool = false) async -> (Bool, String) {
        
        let repositoryValues = RepositoryValues()
        let runningVersion   = AppInfo.version
        
        if !forceCheck {
            Logger.versionCheck.info("skipping version check")
            return (false, runningVersion)
        }
        
        URLCache.shared.removeAllCachedResponses()
        
        var fullVersion     = ""
        var updateAvailable = false

        let configuration = URLSessionConfiguration.ephemeral
        guard let url = repositoryValues.url(for: "version") else {
            Logger.versionCheck.error("could not read URL for latest version")
            return (false, runningVersion)
        }
        var request = URLRequest(url: url)

        request.httpMethod = "GET"
        
        configuration.httpAdditionalHeaders = ["Accept" : "application/json"]
        let session = URLSession(configuration: configuration)

        do {
            
            let checkResult = try await session.data(for: request)
            
            session.finishTasksAndInvalidate()
            if let httpResponse = checkResult.1 as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                Logger.prohibitedVersions.debug("version check successful, HTTP status code: \(httpResponse.statusCode, privacy: .public)")
                let json = try? JSONSerialization.jsonObject(with: checkResult.0, options: .allowFragments)
                if let endpointJSON = json as? [String: Any], let tagName = endpointJSON["tag_name"] as? String {
                    
                    fullVersion = tagName.replacingOccurrences(of: "v", with: "")

                    if Version(runningVersion) < Version(fullVersion) {
                        updateAvailable = true
                    }
                    
                    Logger.versionCheck.info("update available: \(updateAvailable, privacy: .public)")
                    Logger.versionCheck.info("  latest version: \(fullVersion, privacy: .public)")
                    
                } else {
                    Logger.versionCheck.warning("tag_name missing or invalid in response")
                }
            } else {    // if httpResponse.statusCode <200 or >299
                Logger.versionCheck.info("version check response error")
            }
        } catch {
            Logger.prohibitedVersions.debug("an unexpected error occurred: \(error.localizedDescription, privacy: .public)")
        }
//      return (true, "1.2.1")  // for testing
        return (updateAvailable, fullVersion)
    }
}
