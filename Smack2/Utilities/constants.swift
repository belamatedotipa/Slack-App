//
//  constants.swift
//  Smack2
//
//  Created by Bela Mate Barandi on 2/23/18.
//  Copyright © 2018 Bela Mate Barandi. All rights reserved.
//

import Foundation

typealias CompletionHandler = (_ Success: Bool) -> ()


//URL Constants
let BASE_URL = "https://smackslack.herokuapp.com/"
let URL_REGISTER = "\(BASE_URL)account/register"
let URL_LOGIN = "\(BASE_URL)account/login"


//LOCAL URLS - FOR TESTING
let BASE_URL_LOCAL = "http://localhost:3005/v1/"
let URL_REGISTER_LOCAL = "\(BASE_URL_LOCAL)account/register"
let URL_LOGIN_LOCAL = "\(BASE_URL_LOCAL)account/login"
let URL_USER_ADD_LOCAL = "\(BASE_URL_LOCAL)user/add"
let URL_USER_BY_EMAIL = "\(BASE_URL_LOCAL)user/byEmail/"
let URL_GET_CHANNELS = "\(BASE_URL_LOCAL)channel/"


// COLORS
let smackPurplePlaceHolder = #colorLiteral(red: 0.3254901961, green: 0.4196078431, blue: 0.7764705882, alpha: 0.5)

// Notifications
let NOTIF_USER_DATA_DID_CHANGE = Notification.Name("notifUserDataChanged")

// SEGUES
let TO_LOGIN = "toLogin"
let TO_CREATE_ACCOUNT = "toCreateAccount"
let UNWIND = "unwindToChannel"
let TO_AVATAR_PICKER = "toAvatarPicker"



// USER DEFAULTS
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"


// HEADERS

let HEADER = [
    "Content-Type": "application/json"
]

let BEARER_HEADER = [
    "Authorization":"Bearer \(AuthService.instance.authToken)",
    "Content-Type": "application/json"
]



