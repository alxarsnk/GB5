//
//  RealmManager.swift
//  HWExample
//
//  Created by Александр Арсенюк on 03.12.2021.
//

import Foundation
import RealmSwift

class RealmManager {
    
    func save(data: [Friend]) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(data)
            try realm.commitWrite()
            print("Save successful")
        } catch {
            print(error)
        }
    }
    
    func getFrineds() -> [Friend] {
        let realm = try! Realm()
        let listFirneds = realm.objects(Friend.self)
        return Array(listFirneds)
    }
    
}
