//
//  AppDelegate.swift
//  jhc
//
//  Created by Leslie Helou on 5/2/21.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let resourceCheck   = ResourceCheck()
    
    @IBOutlet weak var resetVersionAlert_MenuItem: NSMenuItem!
    @IBAction func resetVersionAlert_Action(_ sender: Any) {
        resetVersionAlert_MenuItem.isEnabled = false
        resetVersionAlert_MenuItem.isHidden = true
        UserDefaults.standard.set(false, forKey: "skipVersionAlert")
    }
    
    @IBAction func checkForUpdates(_ sender: AnyObject) {
        Task {
            let versionCheck = await resourceCheck.version(forceCheck: true)
//            print("versionCheck: \(versionCheck)")
            if versionCheck.0 {
                await Alert.shared.versionDialog(header: "Running \(AppInfo.displayname): v\(AppInfo.version)", version: versionCheck.1, message: "A new version (\(versionCheck.1)) is available.", updateAvail: versionCheck.0, manualCheck: true)
            } else {
                await Alert.shared.versionDialog(header: "Running \(AppInfo.displayname): v\(AppInfo.version)", version: versionCheck.1, message: "No updates are currently available.", updateAvail: versionCheck.0, manualCheck: true)
            }
        }
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        configureTelemetryDeck()
        let resetVersionAlert_Skip = UserDefaults.standard.bool(forKey: "skipVersionAlert")
        resetVersionAlert_MenuItem.isEnabled = resetVersionAlert_Skip
        resetVersionAlert_MenuItem.isHidden  = !resetVersionAlert_Skip
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    // quit the app if the window is closed
    func applicationShouldTerminateAfterLastWindowClosed(_ app: NSApplication) -> Bool {
        return true
    }

}

