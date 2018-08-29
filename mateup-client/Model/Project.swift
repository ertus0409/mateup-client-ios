//
//  Project.swift
//  mateup-client
//
//  Created by Guner Babursah on 29/08/2018.
//  Copyright © 2018 Arthur Developments. All rights reserved.
//

import Foundation

class Project {
    
    var _id: String = ""
    var title: String = ""
    var description: String = ""
    var _datePosted: String = ""
    var postDuration: Double = 24  //in hours
    var contactInfo: String = ""
    var lookingFor: String = ""
    var currentTeam: String = ""
    var _creator: String = ""
    
    static func parseProjectData(data: Data) -> [Project] {
        
        var allProjects = [Project]()
        
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            print(jsonResult)
            if let Dict = jsonResult as? Dictionary<String, AnyObject> {
                if let projects = Dict["projects"] as? [Dictionary<String, AnyObject>] {
                    for project in projects {
                        let newProject = Project()
                        newProject._id = project["_id"] as! String
                        newProject.title = project["title"] as! String
                        newProject.description = project["description"] as! String
//                        if let time = (project["completedAt"] as? Double) {
//                            let date = NSDate(timeIntervalSince1970: (time/1000.0))
//                            newProject.completedAt = date.toString(dateFormat: "yyyy-MM-dd HH:mm")
//                            print(newProject)
//                        }
                        if let timePosted = project["_datePosted"] as? Double {
                            let datePosted = NSDate(timeIntervalSince1970: (timePosted/1000))
                            newProject._datePosted = datePosted.toString(dateFormat: "MM-dd HH:mm")
                        }
                        if let duration = project["postDuration"] as? Double {
                            newProject.postDuration = (duration/1000)/3600  //milliseconds to hours
                        }
                        newProject.contactInfo = project["contactInfo"] as! String
                        newProject.lookingFor = project["lookingFor"] as! String
                        newProject.currentTeam = project["currentTeam"] as! String
                        newProject._creator = project["_creator"] as! String
                        allProjects.append(newProject)
                    }
                }
            }
        } catch let err {
            print(err)
        }
        return allProjects
    }
    
    
    
    static func parseSingleProjectData(data: Data) -> Project {
        
        var newProject: Project?
        
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            print(jsonResult)
            if let project = jsonResult as? Dictionary<String, AnyObject> {
                newProject?._id = project["_id"] as! String
                newProject?.title = project["title"] as! String
                newProject?.description = project["description"] as! String
                if let timePosted = project["_datePosted"] as? Double {
                    let datePosted = NSDate(timeIntervalSince1970: (timePosted/1000))
                    newProject?._datePosted = datePosted.toString(dateFormat: "MM-dd HH:mm")
                }
                if let duration = project["postDuration"] as? Double {
                    newProject?.postDuration = (duration/1000)/3600  //milliseconds to hours
                }
                newProject?.contactInfo = project["contactInfo"] as! String
                newProject?.lookingFor = project["lookingFor"] as! String
                newProject?.currentTeam = project["currentTeam"] as! String
                newProject?._creator = project["_creator"] as! String
            }
        } catch let err {
            print(err)
        }
        return newProject!
    }
    
}
extension NSDate {
    func toString( dateFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self as Date)
    }
}
