//
//  ResultDB.swift
//  ConsumeService
//
//  Created by Leandro Jabur on 12/12/17.
//  Copyright © 2017 Leandro Jabur. All rights reserved.
//

import Foundation
import RealmSwift

class ResultDB: Object {
    
    @objc dynamic var id = NSUUID().uuidString
    @objc dynamic var title: String?
    @objc dynamic var desc: String?
    @objc dynamic var expirationDate: String?
    @objc dynamic var isComplete: Bool = false
    @objc dynamic var isEnviado: Bool = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
