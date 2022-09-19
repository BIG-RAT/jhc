//
//  Alert.swift
//  jhc
//
//  Created by Leslie Helou on 5/2/21.
//  Copyright © 2022 Jamf. All rights reserved.
//

import Cocoa

class Alert: NSObject {
    func display(header: String, message: String) {
        NSApplication.shared.activate(ignoringOtherApps: true)
        let dialog: NSAlert = NSAlert()
        dialog.messageText = header
        dialog.informativeText = message
        dialog.alertStyle = NSAlert.Style.warning
        dialog.addButton(withTitle: "OK")
        dialog.runModal()
    }   // func alert_dialog - end
}
