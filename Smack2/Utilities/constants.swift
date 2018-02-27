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


// SEGUES
let TO_LOGIN = "toLogin"
let TO_CREATE_ACCOUNT = "toCreateAccount"
let UNWIND = "unwindToChannel"


// USER DEFAULTS
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"
