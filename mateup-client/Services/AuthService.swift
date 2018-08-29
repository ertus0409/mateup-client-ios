//
//  AuthService.swift
//  mateup-client
//
//  Created by Guner Babursah on 28/08/2018.
//  Copyright © 2018 Arthur Developments. All rights reserved.
//

import Foundation

class AuthService {
    
    static let instance = AuthService()
    
    let defaults = UserDefaults.standard
    
    var isRegistered: Bool? {
        get{
            return defaults.bool(forKey: DEFAULTS_REGISTERED) == true
        }
        set{
            defaults.set(newValue, forKey: DEFAULTS_REGISTERED)
        }
    }
    
    var isAuthenticated: Bool? {
        get {
            return defaults.bool(forKey: DEFAULTS_AUTHENTICATED) == true
        }
        set {
            defaults.set(newValue, forKey: DEFAULTS_AUTHENTICATED)
        }
    }
    
    var email: String? {
        get{
            return defaults.value(forKey: DEFAULTS_EMAIL) as? String
        }
        set {
            defaults.set(newValue, forKey: DEFAULTS_EMAIL)
        }
    }
    
    var authToken: String? {
        get {
            return defaults.value(forKey: DEFAULTS_TOKEN) as? String
        }
        set {
            defaults.set(newValue, forKey: DEFAULTS_TOKEN)
        }
    }
    
    
    //POST /users
    func registerUser(email: String, password: String, completion: @escaping callback) {
        
        let json = ["email": email, "password": password]
        
        let sessionConfig = URLSessionConfiguration.default
        
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard let URL = URL(string: REGISTER_USER) else {
            isRegistered = false
            completion(false)
            return
        }
        
        var request = URLRequest(url: URL)
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: json, options: [])
            
            let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                if error == nil {
                    //Success
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    print("URL session task succeedde \(statusCode)")
                    if statusCode != 200 {
                        self.isRegistered = false
                        completion(false)
                    } else {
                        guard let tkn = (response as! HTTPURLResponse).allHeaderFields["X-Auth"] as? String else {
                            return
                        }
                        let userToken = tkn
                        self.email = email
                        self.authToken = userToken
                        self.isAuthenticated = true
                        self.isRegistered = true
                        completion(true)
                    }
                } else {
                    //Failure
                    completion(false)
                    print("URL session task failed", error)
                }
            })
            task.resume()
            session.finishTasksAndInvalidate()
        } catch let err {
            self.isRegistered = false
            completion(false)
            print(err)
        }
    }
    
    
    //POST /users/login
    func logInUser(email: String, password: String, completion: @escaping callback) {
        
        let json = ["email": email, "password": password]
        
        let sessionConfig = URLSessionConfiguration.default
        
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard let URL = URL(string: LOGIN_USER) else {
            isAuthenticated = false
            completion(false)
            return
        }
        
        var request = URLRequest(url: URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: json, options: [])
            
            let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                if error == nil {
                    //Success
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    print("URL session succeed \(statusCode)")
                    if statusCode != 200 {
                        self.isAuthenticated = false
                        completion(false)
                        return
                    } else {
                        print("heey")
                        guard let tkn = (response as! HTTPURLResponse).allHeaderFields["X-Auth"] as? String else {
                            return
                        }
//                        let userToken = tkn
                        guard let data = data else {
                            completion(false)
                            return
                        }
                        do {
                            let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, AnyObject>
                            
                            if result != nil {
                                if let email = result!["email"] as? String {
                                    self.email = email
                                    self.isRegistered = true
                                    self.authToken = tkn
                                    print("USER TOKEN: \(tkn)")
                                    self.isAuthenticated = true
                                    completion(true)
                                } else {
                                    completion(false)
                                }
                            } else {
                                completion(false)
                            }
                        } catch let err {
                            completion(false)
                            print(err)
                        }
                    }
                } else {
                    completion(false)
                    return
                }
            })
            task.resume()
            session.finishTasksAndInvalidate()
        } catch let err {
            isAuthenticated = false
            completion(false)
            print(err)
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

