//
//  ModelService.swift
//  ConsumeService
//
//  Created by Leandro Jabur on 12/6/17.
//  Copyright © 2017 Leandro Jabur. All rights reserved.
//

import Foundation
import EasyRest
import Genome

var loginModel = Login()

class Login: BaseModel {
    var access_token: String?
    var expires_in: Int?
    var token_type: String?
    var scope: String?
    var refresh_token: String?
    
    override func sequence(_ map: Map) throws {
        try access_token <~> map["access_token"]
        try expires_in <~ map["expires_in"]
        try token_type <~> map["token_type"]
        try scope <~ map["scope"]
        try refresh_token <~ map["refresh_token"]
    }
    
}

class Tasks: BaseModel {
    var count: Int?
    var next: String?
    var previous: String?
    var results: [Task]?
    
    override func sequence(_ map: Map) throws {
        try count <~> map["count"]
        try next <~> map["next"]
        try previous <~> map["previous"]
        try results <~> map["results"]
    }
    
}

class Task: BaseModel {
    var id: String?
    var expiration_date: String?
    var title: String?
    var description1: String?
    var is_complete: Bool?
    var owner: String?
    
    override func sequence(_ map: Map) throws {
        try id <~> map["id"]
        try expiration_date <~> map["expiration_date"]
        try title <~> map["title"]
        try description1 <~> map["description"]
        try is_complete <~> map["is_complete"]
        try owner <~> map["owner"]
    }
}


