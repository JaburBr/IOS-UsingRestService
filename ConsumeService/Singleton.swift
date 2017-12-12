//
//  Singleton.swift
//  ConsumeService
//
//  Created by Leandro Jabur on 12/12/17.
//  Copyright © 2017 Leandro Jabur. All rights reserved.
//

import Foundation
import RealmSwift

class Repository{
    
    static let bd = try! Realm(configuration:
        Realm.Configuration(schemaVersion: 1,
        
        migrationBlock: { migration, oldSchemaVersion in
            if (oldSchemaVersion < 1){
                
            }
    })
    )
    
    fileprivate init() { }
    
}
