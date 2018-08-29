//
//  DataService.swift
//  mateup-client
//
//  Created by Guner Babursah on 29/08/2018.
//  Copyright © 2018 Arthur Developments. All rights reserved.
//

import Foundation

protocol DataServiceDelegate: class {
    func projectsLoaded()
}

class DataService {
    
    static let instance = DataService()
    
    weak var delegate: DataServiceDelegate?
    var projects = [Project]()
    var selectedProject: Project?
    
    
    
    //GET ALL PROJECTS
    func getAllProjects() {
        guard let tkn = AuthService.instance.authToken, tkn != "" else {
            print("NO token")
            return
        }
        guard let auth = AuthService.instance.isAuthenticated, auth == true else {
            print("Not authenticated")
            return
        }
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        guard let URL = URL(string: GET_PROJECTS) else { return }
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
//        request.addValue(tkn, forHTTPHeaderField: "x-auth")
        
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            if error == nil {
                //Succes
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL session succeeded: \(statusCode)")
                if let data = data {
                    self.projects = Project.parseProjectData(data: data)
                    self.delegate?.projectsLoaded()
                }
            } else {
                //Failure
                print(error)
//                completion(false)
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    //GET project by id
    func getProjectById(id: String) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        guard let URL = URL(string: "\(BASE_URL)/\(id)") else {return}
        
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        guard let tkn = AuthService.instance.authToken, tkn != "" else {
            return
        }
        request.addValue(tkn, forHTTPHeaderField: "x-auth")
        
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            if error == nil {
                //Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("Url session succeeded: \(statusCode)")
                if let data = data {
                    self.selectedProject = Project.parseSingleProjectData(data: data)
                    self.delegate?.projectsLoaded()
                }
                
            } else {
                print("URL session task FAILED: \(error?.localizedDescription)")
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    
    
    //POST new project
    func postTodo(title: String, description: String, postDuration: Double, contactInfo: String, lookingFor: String, currentTeam: String, completion: @escaping callback) {
        guard let tkn = AuthService.instance.authToken, tkn != "" else {
            print("NO token")
            return
        }
        guard let auth = AuthService.instance.isAuthenticated, auth == true else {
            print("Not authenticated")
            return
        }
        
        let json = [
                        "title": title,
                        "description": description,
                        "postDuration": postDuration,
                        "contactInfo": contactInfo,
                        "lookingFor": lookingFor,
                        "currentTeam": currentTeam
            ] as [String : Any]
        
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        guard let URL = URL(string: POST_PROJECTS) else { return }
        var request = URLRequest(url: URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(tkn, forHTTPHeaderField: "x-auth")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: json, options: [])
            let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                if error == nil {
                    //Success
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    if statusCode != 200 {
                        //Error
                        print("Error posting the todo: \(error)")
                        completion(false)
                    } else {
                        completion(true)
                        self.delegate?.projectsLoaded()
                    }
                } else {
                    completion(false)
                    print(error)
                }
            })
            task.resume()
            session.finishTasksAndInvalidate()
        } catch let err {
            print(err)
            completion(false)
        }
    }
    
    
    //DELETE project
    func deleteTodo(_id: String, completion: @escaping callback) {
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        guard let URL = URL(string: "\(DELETE_PROJECTS)\(_id)") else { return }
        var request = URLRequest(url: URL)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let tkn = AuthService.instance.authToken, tkn != "" else { return }
        request.addValue(tkn, forHTTPHeaderField: "x-auth")
        
        do {
            let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                if error == nil {
                    //Success
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    if statusCode != 200 {
                        completion(false)
                        print("Couldnt delete todo http: \(statusCode)")
                    } else {
                        print("Todo deleted HTTP: \(statusCode)")
                        completion(true)
                    }
                } else {
                    print("An error has occured: \(error)")
                }
            })
            task.resume()
            session.finishTasksAndInvalidate()
        } catch let err {
            completion(false)
            print(err)
        }
    }
    
    
//    //PATCH edit
//    func updateTodo(_id: String, completed: Bool, completion: @escaping callback) {
//        let json = ["completed": completed]
//
//        let sessionConfig = URLSessionConfiguration.default
//        let session = URLSession(configuration: sessionConfig)
//        guard let URL = URL(string: "\(PATCH_TODO)\(_id)") else { return }
//        var request = URLRequest(url: URL)
//        request.httpMethod = "PATCH"
//        guard let tkn = AuthService.instance.authToken, tkn != "" else { return }
//        request.addValue(tkn, forHTTPHeaderField: "x-auth")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: json, options: [])
//            let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
//                if error == nil {
//                    //Success
//                    let statusCode = (response as! HTTPURLResponse).statusCode
//                    if statusCode != 200 {
//                        //Error
//                        print("Cant patch todo HTTP: \(statusCode)")
//                        completion(false)
//                    } else {
//                        print("Todo patch successfull: \(statusCode)")
//                        DataService.instance.getAllTodos()
//                        completion(true)
//                    }
//                } else {
//                    //ERROR
//                    print("Anne rror has occured: \(error)")
//                }
//            })
//            task.resume()
//            session.finishTasksAndInvalidate()
//        } catch let err {
//            completion(false)
//            print(err)
//        }
//    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

