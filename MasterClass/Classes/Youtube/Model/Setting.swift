//
//  Setting.swift
//  youttube
//
//  Created by James Czepiel on 10/5/18.
//  Copyright © 2018 James Czepiel. All rights reserved.
//

import Foundation

struct Setting {
    let name: SettingName
    let imageName: String
    
    static var allSettings: [Setting] {
        let settings = Setting(name: .settings, imageName: "settings")
        let terms = Setting(name: .terms, imageName: "privacy")
        let send = Setting(name: .send, imageName: "feedback")
        let help = Setting(name: .help, imageName: "help")
        let switchAccount = Setting(name: .switchAccount, imageName: "account")
        let cancel = Setting(name: .cancel, imageName: "cancel")

        return [settings, terms, send, help, switchAccount, cancel]
    }
}

enum SettingName: String {
    case cancel = "Cancel"
    case settings = "Setting"
    case terms = "Terms and Privacy Policy"
    case send = "Send Feedback"
    case help = "Help"
    case switchAccount = "Switch Account"
}
