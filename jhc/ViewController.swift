//
//  ViewController.swift
//  jhc
//
//  Created by Leslie Helou on 5/2/21.
//

import Cocoa

class ViewController: NSViewController, NSTextFieldDelegate {
    
    @IBAction func windowType_action(_ sender: NSButton) {
        var option = ""
        let selection = "\(sender.title)"
        switch selection {
        case "Heads Up Display":
            option = "hud"
        case "Utility":
            option = "utility"
        default:
            option = "fs"
        }
        jamfHelperOptions["-windowType"] = option
        if jamfHelperOptions["-windowType"] as! String == "hud" {
            lockHUD_button.isHidden = false
        } else {
            lockHUD_button.isHidden       = true
            jamfHelperOptions["-lockHUD"] = nil
        }
        generateCommand()
    }
    
    @IBOutlet weak var lockHUD_button: NSButton!
    @IBAction func lockHUD_action(_ sender: NSButton) {
        if lockHUD_button.state.rawValue == 1 {
            jamfHelperOptions["-lockHUD"] = ""
        } else {
            jamfHelperOptions["-lockHUD"] = nil
        }
        generateCommand()
    }
    
    @IBAction func windowPosition(_ sender: NSButton) {
        var option = ""
        let selection = "\(sender.title)"
        switch selection {
        case "Center":
            option = ""
        case "Upper Left":
            option = "ul"
        case "Upper Right":
            option = "ur"
        case "Lower Left":
            option = "ll"
        default:
            option = "lr"
        }
        if option != "" {
            jamfHelperOptions["-windowPosition"] = option
        } else {
            jamfHelperOptions["-windowPosition"] = nil
        }
        generateCommand()
    }
    
    @IBOutlet weak var title_textfield: NSTextField!
    
    @IBOutlet weak var heading_textfield: NSTextField!
    @IBOutlet weak var headerAlignLeft_button: NSButton!
    @IBOutlet weak var headerAlignCenter_button: NSButton!
    @IBOutlet weak var headerAlignRight_button: NSButton!
    @IBOutlet weak var headerAlignJustified_button: NSButton!
    @IBOutlet weak var headerAlignNatural_button: NSButton!
    
    @IBOutlet weak var description_textfield: NSTextField!
    @IBOutlet weak var descriptionAlignLeft_button: NSButton!
    @IBOutlet weak var descriptionAlignCenter_button: NSButton!
    @IBOutlet weak var descriptionAlignRight_button: NSButton!
    @IBOutlet weak var descriptionAlignJustified_button: NSButton!
    @IBOutlet weak var descriptionAlignNatural_button: NSButton!
    
    @IBAction func textAlign_action(_ sender: NSButton) {
//        print("alignment button: \(sender.identifier!.rawValue)")
//        sender.isBordered = true
        
        let textAlignArray = "\(sender.identifier!.rawValue)".split(separator: ".")
        if textAlignArray[0] == "Heading" {
            headerAlignLeft_button.isBordered      = (sender.identifier!.rawValue == "Heading.left") ? true:false
            headerAlignCenter_button.isBordered    = (sender.identifier!.rawValue == "Heading.center") ? true:false
            headerAlignRight_button.isBordered     = (sender.identifier!.rawValue == "Heading.right") ? true:false
            headerAlignJustified_button.isBordered = (sender.identifier!.rawValue == "Heading.justified") ? true:false
            headerAlignNatural_button.isBordered   = (sender.identifier!.rawValue == "Heading.natural") ? true:false
        } else {
            descriptionAlignLeft_button.isBordered      = (sender.identifier!.rawValue == "Description.left") ? true:false
            descriptionAlignCenter_button.isBordered    = (sender.identifier!.rawValue == "Description.center") ? true:false
            descriptionAlignRight_button.isBordered     = (sender.identifier!.rawValue == "Description.right") ? true:false
            descriptionAlignJustified_button.isBordered = (sender.identifier!.rawValue == "Description.justified") ? true:false
            descriptionAlignNatural_button.isBordered   = (sender.identifier!.rawValue == "Description.natural") ? true:false
        }
        
        var currentOptions = jamfHelperOptions.count
//        let option = "\(sender.identifier!.rawValue)"
//        let textAlignArray = option.split(separator: ".")
        jamfHelperOptions["-align\(textAlignArray[0])"] = "\(textAlignArray[1])"
        if heading_textfield.stringValue == "" {
            jamfHelperOptions["-alignHeading"] = nil
        } else {
            currentOptions -= 1
        }
        if description_textfield.stringValue == "" {
            jamfHelperOptions["-alignDescription"] = nil
        } else {
            currentOptions -= 1
        }
        if currentOptions != jamfHelperOptions.count {
            generateCommand()
        }
    }
    
    @IBAction func icon_action(_ sender: NSButton) {
        if sender.state.rawValue == 0 {
            iconPath_button.isEnabled = false
            iconSizeLabel(enableState: false)
        } else {
            iconPath_button.isEnabled = true
        }
    }
    
    @IBOutlet weak var iconPath_button: NSPathControl!
    @IBOutlet weak var iconSize_label: NSTextField!
    @IBOutlet weak var iconSizeDefault_label: NSButton!
    @IBOutlet weak var iconSizeCustom_label: NSButton!
    @IBOutlet weak var iconSizeFullScreen_label: NSButton!
    @IBOutlet weak var iconSizeSlider_button: NSSlider!
    
    @IBAction func slider_action(_ sender: NSButton) {
        switch sender.title {
        case "default":
            iconSizeSlider_button.intValue = 0
            jamfHelperOptions["-iconSize"] = nil
            iconSize_textfield.isEnabled = false
            jamfHelperOptions["-fullScreenIcon"] = nil
            iconSize_textfield.stringValue = ""
        case "custom":
            iconSizeSlider_button.intValue = 50
            iconSize_textfield.isEnabled = true
            jamfHelperOptions["-fullScreenIcon"] = nil
        default:
            // full screen
            iconSizeSlider_button.intValue = 100
            jamfHelperOptions["-iconSize"] = nil
            iconSize_textfield.isEnabled = false
            jamfHelperOptions["-fullScreenIcon"] = ""
            iconSize_textfield.stringValue = ""
        }
        generateCommand()
    }
 
    @IBAction func iconSize_slider(_ sender: NSButton) {
//        print("\(sender.doubleValue)")
        switch sender.doubleValue {
        case 0.0:
            jamfHelperOptions["-iconSize"] = nil
            iconSize_textfield.isEnabled = false
            jamfHelperOptions["-fullScreenIcon"] = nil
            iconSize_textfield.stringValue = ""
        case 50.0:
            iconSize_textfield.isEnabled = true
            jamfHelperOptions["-fullScreenIcon"] = nil
        default:
            // full screen
            jamfHelperOptions["-iconSize"] = nil
            iconSize_textfield.isEnabled = false
            jamfHelperOptions["-fullScreenIcon"] = ""
            iconSize_textfield.stringValue = ""
        }
        generateCommand()
    }
    @IBOutlet weak var iconSize_textfield: NSTextField!
    
    
    @IBOutlet weak var button1_button: NSButton!
    @IBOutlet weak var button2_button: NSButton!
    
    @IBOutlet weak var button1Label_textfield: NSTextField!
    @IBOutlet weak var button2Label_textfield: NSTextField!
    
    @IBAction func button1_action(_ sender: NSButton) {
        if sender.state.rawValue == 0 {
            button1Default_button.isEnabled  = false
            button1Cancel_button.isEnabled   = false
            button1Label_textfield.isEnabled = false
            button1Label_textfield.stringValue = ""
            button2_button.isEnabled         = false
            button2Default_button.isEnabled  = false
            button2Cancel_button.isEnabled   = false
            button2Label_textfield.stringValue = ""
            jamfHelperOptions["-button1"]    = nil
            generateCommand()
        } else {
            button1Default_button.isEnabled  = true
            button1Cancel_button.isEnabled   = true
            button1Label_textfield.isEnabled = true
            button2_button.isEnabled         = true
        }
    }
    
    @IBAction func button2_action(_ sender: NSButton) {
        if sender.state.rawValue == 0 {
            button2Default_button.isEnabled  = false
            button2Cancel_button.isEnabled   = false
            button2Label_textfield.stringValue = ""
            button2Label_textfield.isEnabled = false
            jamfHelperOptions["-button2"]    = nil
            generateCommand()
        } else {
            button2Default_button.isEnabled  = true
            button2Cancel_button.isEnabled   = true
            button2Label_textfield.isEnabled = true
        }
    }
    
    @IBOutlet weak var button1Default_button: NSButton!
    @IBOutlet weak var button1Cancel_button: NSButton!
    @IBOutlet weak var button2Default_button: NSButton!
    @IBOutlet weak var button2Cancel_button: NSButton!
    
    @IBAction func defaultbutton_action(_ sender: NSButton) {
        if sender.identifier!.rawValue.contains("button1") {
            button2Default_button.state = NSControl.StateValue.off
            if sender.state.rawValue == 1 {
                jamfHelperOptions["-defaultButton"] = 1
            } else {
                jamfHelperOptions["-defaultButton"] = nil
            }
        } else {
            button1Default_button.state = NSControl.StateValue.off
            if sender.state.rawValue == 1 {
                jamfHelperOptions["-defaultButton"] = 2
            } else {
                jamfHelperOptions["-defaultButton"] = nil
            }
        }
        generateCommand()
    }
    @IBAction func cancelbutton_action(_ sender: NSButton) {
        if sender.identifier!.rawValue.contains("button1") {
            button2Cancel_button.state = NSControl.StateValue.off
            if sender.state.rawValue == 1 {
                jamfHelperOptions["-cancelButton"] = 1
            } else {
                jamfHelperOptions["-cancelButton"] = nil
            }
        } else {
            button1Cancel_button.state = NSControl.StateValue.off
            if sender.state.rawValue == 1 {
                jamfHelperOptions["-cancelButton"] = 2
            } else {
                jamfHelperOptions["-cancelButton"] = nil
            }
        }
        generateCommand()
    }
    
    @IBAction func delayOptions_action(_ sender: NSButton) {
        if sender.state.rawValue == 0 {
            delayOptions_textfield.stringValue = ""
            delayOptions_textfield.isEnabled = false
            jamfHelperOptions["-showDelayOptions"] = nil
            generateCommand()
        } else {
            delayOptions_textfield.isEnabled = true
        }
        
    }
    @IBOutlet weak var delayOptions_textfield: NSTextField!
    
    @IBAction func timeOut_action(_ sender: NSButton) {
        if sender.state.rawValue == 0 {
            timeOut_textfield.stringValue = ""
            timeOut_textfield.isEnabled   = false
            countdown_button.isEnabled    = false
            jamfHelperOptions["-timeout"] = nil
            resetCountdownAlign()
            generateCommand()
        } else {
            timeOut_textfield.isEnabled   = true
        }
    }
    @IBOutlet weak var timeOut_textfield: NSTextField!
    
    
    @IBOutlet weak var countdown_button: NSButton!
    @IBAction func countdown_action(_ sender: NSButton) {
        if sender.state.rawValue == 0 {
            countdownAlignLeft_button.isEnabled      = false
            countdownAlignCenter_button.isEnabled    = false
            countdownAlignRight_button.isEnabled     = false
            countdownAlignJustified_button.isEnabled = false
            countdownAlignNatural_button.isEnabled   = false
            resetCountdownAlign()
            jamfHelperOptions["-countdown"]      = nil
            jamfHelperOptions["-alignCountdown"] = nil
            generateCommand()
        } else {
            countdownAlignLeft_button.isEnabled      = true
            countdownAlignCenter_button.isEnabled    = true
            countdownAlignRight_button.isEnabled     = true
            countdownAlignJustified_button.isEnabled = true
            countdownAlignNatural_button.isEnabled   = true
            jamfHelperOptions["-countdown"] = ""
        }
        generateCommand()
    }
    
    @IBOutlet weak var countdownAlignLeft_button: NSButton!
    @IBOutlet weak var countdownAlignCenter_button: NSButton!
    @IBOutlet weak var countdownAlignRight_button: NSButton!
    @IBOutlet weak var countdownAlignJustified_button: NSButton!
    @IBOutlet weak var countdownAlignNatural_button: NSButton!
    
    @IBAction func countdownAlign_action(_ sender: NSButton) {
        countdownAlignLeft_button.isBordered      = (sender.identifier!.rawValue == "alignCountdown.left") ? true:false
        countdownAlignCenter_button.isBordered    = (sender.identifier!.rawValue == "alignCountdown.center") ? true:false
        countdownAlignRight_button.isBordered     = (sender.identifier!.rawValue == "alignCountdown.right") ? true:false
        countdownAlignJustified_button.isBordered = (sender.identifier!.rawValue == "alignCountdown.justified") ? true:false
        countdownAlignNatural_button.isBordered   = (sender.identifier!.rawValue == "alignCountdown.natural") ? true:false
        let countdownAlignArray = "\(sender.identifier!.rawValue)".split(separator: ".")
        jamfHelperOptions["-\(countdownAlignArray[0])"] = "\(countdownAlignArray[1])"
        generateCommand()
    }
    
    
    @IBAction func iconPath(_ sender: NSPathControl) {
        iconSizeSlider_button.isEnabled = true
//        print("icon set")
//        print("the path: \(sender.url!)")
//        let theURL = sender.url!
//        let thePath = String(contentsOf: theURL)
//        print("thePath: \(theURL.path)")
        iconSizeLabel(enableState: true)
        jamfHelperOptions["-icon"] = "\"\(sender.url!.path)\""
        iconSizeLabel(enableState: true)
        generateCommand()
    }
    
    @IBAction func copy_Button(_ sender: Any) {
        let clipboard = NSPasteboard.general
        clipboard.clearContents()
        clipboard.setString(currentCommant_textview.string, forType: .string)
    }
    
    @IBOutlet var currentCommant_textview: NSTextView!
    
    @IBAction func preview_button(_ sender: Any) {
        if FileManager.default.fileExists(atPath: "/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper") {
            let previewQ     = DispatchQueue(label: "com.jamf.previewQ", qos: DispatchQoS.background)
            var optionsArray = [String]()
    //        var localStatus  = [String]()
    //        let pipe    = Pipe()
            let task    = Process()
            task.launchPath     = "/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
            
            for (option, value) in jamfHelperOptions {
                optionsArray.append("\(option)")
                if "\(value)" != "" {
                    optionsArray.append("\(value)")
                }
            }
            
            task.arguments      = optionsArray

            previewQ.async {

                task.launch()
                
                sleep(15)

                let task_kill        = Process()
                task_kill.launchPath = "/usr/bin/killall"
                task_kill.arguments  = ["jamfHelper"]
                task_kill.launch()
                task_kill.waitUntilExit()
            
            }
        } else {
            Alert().display(header: "Attention:", message: "Unable to locate jamfHelper.  Note, machine must be enrolled to use the Preview feature.")
        }
    }
    
    
    let jamfHelperBinary = "/Library/Application\\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
    var jamfHelperOptions = [String:Any]()
    
    
    func controlTextDidChange(_ obj: Notification) {
        if let textField = obj.object as? NSTextField {
//            let option = "\(textField.identifier!.rawValue)"
//            print("\(textField.identifier!.rawValue)")
             switch "\(textField.identifier!.rawValue)" {
             case "iconSize":
                jamfHelperOptions["-iconSize"] = "\(iconSize_textfield.stringValue)"
                if jamfHelperOptions["-iconSize"] as! String == "" {
                    jamfHelperOptions["-iconSize"] = nil
                }
             case "title":
                 jamfHelperOptions["-title"] = "\"\(title_textfield.stringValue)\""
                 if jamfHelperOptions["-title"] as! String == "\"\"" {
                     jamfHelperOptions["-title"] = nil
                 }
             case "heading":
                 jamfHelperOptions["-heading"] = "\"\(heading_textfield.stringValue)\""
                 if jamfHelperOptions["-heading"] as! String == "\"\"" {
                     jamfHelperOptions["-heading"]     = nil
                    jamfHelperOptions["-alignHeading"] = nil
                 }
             case "description":
                jamfHelperOptions["-description"] = "\"\(description_textfield.stringValue)\""
                if jamfHelperOptions["-description"] as! String == "\"\"" {
                    jamfHelperOptions["-description"]      = nil
                    jamfHelperOptions["-alignDescription"] = nil
                }
             case "button1":
                jamfHelperOptions["-button1"] = "\"\(button1Label_textfield.stringValue)\""
                if jamfHelperOptions["-button1"] as! String == "\"\"" {
                    jamfHelperOptions["-button1"] = nil
                }
             case "button2":
                jamfHelperOptions["-button2"] = "\"\(button2Label_textfield.stringValue)\""
                if jamfHelperOptions["-button2"] as! String == "\"\"" {
                    jamfHelperOptions["-button2"] = nil
                }
             case "delayOptions":
                jamfHelperOptions["-showDelayOptions"] = "\"\(delayOptions_textfield.stringValue)\""
                if jamfHelperOptions["-showDelayOptions"] as! String == "\"\"" {
                    jamfHelperOptions["-showDelayOptions"] = nil
                }
             case "timeOut":
                jamfHelperOptions["-timeout"] = "\(timeOut_textfield.stringValue)"
                if jamfHelperOptions["-timeout"] as! String == "" {
                    jamfHelperOptions["-timeout"] = nil
                    countdown_button.isEnabled    = false
                    resetCountdownAlign()
                } else {
                    countdown_button.isEnabled = true
                }
             default:
                break
             }
             
            if textField.identifier!.rawValue == "search" {
            }
        }
        jamfHelperOptions["-title"] = "\"\(title_textfield.stringValue)\""
        if jamfHelperOptions["-title"] as! String == "\"\"" {
            jamfHelperOptions["-title"] = nil
        }
        generateCommand()
    }
    
    func generateCommand() {
        var command = jamfHelperBinary
        for (option, value) in jamfHelperOptions {
            command = command + " \(option)"
            if "\(value)" != "" {
                command = command + " \(value)"
            }
        }
        DispatchQueue.main.async { [self] in
            currentCommant_textview.string = command
        }
    }
    
    func iconDisplay(enable: Bool) {
        iconSizeSlider_button.isEnabled = enable
//        iconSize_textfield.stringValue = ""
//        iconSize_textfield.isEnabled = enable
    }
    
    func iconSizeLabel(enableState: Bool) {
        iconSizeDefault_label.isEnabled    = enableState
        iconSizeCustom_label.isEnabled     = enableState
        iconSizeFullScreen_label.isEnabled = enableState
        iconSizeSlider_button.isEnabled    = enableState
        iconSize_textfield.isEnabled       = enableState
        if !enableState {
            iconSize_textfield.stringValue = ""
        }
    }
    
    func resetCountdownAlign() {
        countdown_button.state = NSControl.StateValue.off
        jamfHelperOptions["-alignCountdown"] = nil
        countdownAlignLeft_button.isBordered = false
        countdownAlignLeft_button.isEnabled  = false
        countdownAlignCenter_button.isBordered = false
        countdownAlignCenter_button.isEnabled  = false
        countdownAlignRight_button.isBordered = false
        countdownAlignRight_button.isEnabled  = false
        countdownAlignJustified_button.isBordered = false
        countdownAlignJustified_button.isEnabled  = false
        countdownAlignNatural_button.isBordered = false
        countdownAlignNatural_button.isEnabled  = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title_textfield.delegate        = self
        heading_textfield.delegate      = self
        description_textfield.delegate  = self
        iconSize_textfield.delegate     = self
        button1Label_textfield.delegate = self
        button2Label_textfield.delegate = self
        delayOptions_textfield.delegate = self
        timeOut_textfield.delegate      = self
        
        currentCommant_textview.font = NSFont(name: "Courier", size: CGFloat(14))
        
        jamfHelperOptions["-windowType"] = "hud"
//        jamfHelperOptions["-windowPosition"] = "ul"
        generateCommand()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

