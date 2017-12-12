//
//  CurlInterceptor.swift
//  ConsumeService
//
//  Created by Leandro Jabur on 12/8/17.
//  Copyright © 2017 Leandro Jabur. All rights reserved.
//

import Foundation
import EasyRest
import Alamofire
import Genome

class CurlInterceptor: Interceptor {
    
    let token = UserDefaults.standard.string(forKey: Config.token)!
    
    func requestInterceptor<T>(_ api: API<T>) where T : NodeInitializable {
        api.headers["Authorization"] = "Bearer \(token ?? "")"
    }
    
    func responseInterceptor<T>(_ api: API<T>, response: DataResponse<Any>) where T : NodeInitializable {
        
    }
    
    required init(){
        
    }
    
    
    
    
}
