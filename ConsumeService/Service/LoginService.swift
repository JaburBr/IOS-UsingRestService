//
//  LoginService.swift
//  ConsumeService
//
//  Created by Leandro Jabur on 12/6/17.
//  Copyright © 2017 Leandro Jabur. All rights reserved.
//

import Foundation
import EasyRest

class LoginService: Service<ServicesRoute>{
    
    override var base: String { return Config.kHttpEndpoint }
    
    
    func getLogin(user: String, password: String, onSuccess: @escaping (Response<Login>?) -> Void,
                  onError: @escaping (RestError?) -> Void,
                  always: @escaping () -> Void) {
        try! call(.getLogin(user: user,password: password), type: Login.self, onSuccess: onSuccess,
                  onError: onError, always: always)
    }
    
}
