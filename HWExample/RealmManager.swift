//
//  RealmManager.swift
//  HWExample
//
//  Created by Александр Арсенюк on 03.12.2021.
//

import Foundation
import RealmSwift

class RealmManager {
    
    func save<T: Object>(data: [T]) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(data, update: .all)
            try realm.commitWrite()
            print("Save successful")
        } catch {
            print(error)
        }
    }
    
    func getFrineds<T: Object>() -> [T] {
        let realm = try! Realm()
        let listFirneds = realm.objects(T.self)
        return Array(listFirneds)
    }
    
}
