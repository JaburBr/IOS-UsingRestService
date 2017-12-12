//
//  TasksService.swift
//  ConsumeService
//
//  Created by Leandro Jabur on 12/8/17.
//  Copyright © 2017 Leandro Jabur. All rights reserved.
//

import Foundation
import EasyRest

class TasksService: Service<ServicesRoute>{
    
    override var base: String { return Config.kHttpEndpoint }
    override var interceptors: [Interceptor]? { return [CurlInterceptor()] }
    
    
    func getTasks(onSuccess: @escaping (Response<Tasks>?) -> Void,
                  onError: @escaping (RestError?) -> Void,
                  always: @escaping () -> Void) {
        try! call(.getTasks, type: Tasks.self, onSuccess: onSuccess,
                  onError: onError, always: always)
    }
    
    func salvarTask(task: Task, Success: @escaping (Response<Task>?) -> Void,
                    onError: @escaping (RestError?) -> Void,
                    always: @escaping () -> Void) {
        try! call(.salvarTask(task: task), type: Task.self, onSuccess: Success,
                  onError: onError, always: always)
    }
    
    func editarTask(task: Task, Success: @escaping (Response<Task>?) -> Void,
                    onError: @escaping (RestError?) -> Void,
                    always: @escaping () -> Void) {
        try! call(.editarTask(task: task), type: Task.self, onSuccess: Success,
                  onError: onError, always: always)
    }
    
    func deleteTask(task: Task, Success: @escaping (Response<Task>?) -> Void,
                    onError: @escaping (RestError?) -> Void,
                    always: @escaping () -> Void) {
        try! call(.deleteTask(task: task), type: Task.self, onSuccess: Success,
                  onError: onError, always: always)
    }
    
}
