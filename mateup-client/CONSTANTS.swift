//
//  CONSTANTS.swift
//  mateup-client
//
//  Created by Guner Babursah on 28/08/2018.
//  Copyright © 2018 Arthur Developments. All rights reserved.
//

import Foundation

//Callbacks :
//Typealias used for callbacks DataService
typealias callback = (_ success: Bool) -> ()


let BASE_URL = "https://still-badlands-60549.herokuapp.com"


//DATA
let GET_PROJECTS = "\(BASE_URL)/projects"
let POST_PROJECTS = "\(BASE_URL)/projects"
let DELETE_PROJECTS = "\(BASE_URL)/projects"


//AUTH
let REGISTER_USER = "\(BASE_URL)/users"
let LOGIN_USER = "\(BASE_URL)/users/login"
let LOGOUT_USER = "\(BASE_URL)/users/logout"

//Boolean Auth UserDefaults keys
let DEFAULTS_REGISTERED = "isRegistered"
let DEFAULTS_AUTHENTICATED = "isAuthenticated"

//Auth Email
let DEFAULTS_EMAIL = "email"

//Auth Toekn
let DEFAULTS_TOKEN = "authToken"


