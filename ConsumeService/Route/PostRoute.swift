//
//  PostRoute.swift
//  ConsumeService
//
//  Created by Leandro Jabur on 12/6/17.
//  Copyright © 2017 Leandro Jabur. All rights reserved.
//

import Foundation
import EasyRest

enum ServicesRoute: Routable {
    
    case getLogin(user: String, password: String)
    case getTasks
    case salvarTask(task: Task)
    case editarTask(task: Task)
    case deleteTask(task: Task)
    
    var rule: Rule {
        switch self {
        case let .getLogin(user, password):
            return Rule(method: .post, path: "/oauth/token/",
                        isAuthenticable: false, parameters: [.query:["client_id":Config.clientId,   "client_secret":Config.clientSecret, "grant_type":Config.grantTypePassword,         "username": user,
                            "password": password]])
            
        case .getTasks:
            return Rule(method: .get, path: "/v1/tasks/", isAuthenticable: false, parameters: [:])
            
        case let .salvarTask(task):
            return Rule(method: .post, path: "/v1/tasks/",
                        isAuthenticable: false, parameters: [.body: task])
        
        case let .editarTask(task):
            return Rule(method: .put, path: "/v1/tasks/\(task.id ?? "")/",
                isAuthenticable: false, parameters: [.body: task])
            
        case let .deleteTask(task):
            return Rule(method: .delete, path: "/v1/tasks/\(task.id ?? "")/",
                isAuthenticable: false, parameters: [.body: task])
        }
    }
    
}
