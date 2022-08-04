//
//  Constants.swift
//  Flash Chat iOS13
//
//  Created by Eugeniu Garaz on 8/4/22.
//  Copyright © 2022 Angela Yu. All rights reserved.
//

struct Constants {
    static let appName              = "⚡️FlashChat"
    static let cellIdentifier       = "ReusableCell"
    static let cellNibName          = "MessageCell"
    static let registerSegue        = "RegisterToChat"
    static let loginSegue           = "LoginToChat"

    struct BrandColors {
        static let purple           = "BrandPurple"
        static let lightPurple      = "BrandLightPurple"
        static let blue             = "BrandBlue"
        static let lightBlue        = "BrandLightBlue"
    }
    
    struct FStore {
        static let colletionName    = "messages"
        static let senderField      = "sender"
        static let bodyField        = "body"
        static let dateField        = "date"
    }
}
