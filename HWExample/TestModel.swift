//
//  TestModel.swift
//  HWExample
//
//  Created by Александр Арсенюк on 03.12.2021.
//

import Foundation
import Realm
import RealmSwift


class StepCounter: Object {
    @objc dynamic var steps = 1
}

@objcMembers
class Dog: Object {
    
    dynamic var name = ""
    dynamic var age = 0
    
}

@objcMembers
class TestEntity: Object {
    dynamic var name = ""
    dynamic var age = 0
    dynamic var lastName = ""
    
    let pets = List<TestPet>()
    
    dynamic var id = 0
    
//    override static func primaryKey() -> String? {
//        return "id"
//    }
    
    override static func indexedProperties() -> [String] {
        return ["name"]
    }
    
    static override func ignoredProperties() -> [String] {
        return ["lastName"]
    }
    
}


class TestPet: Object {
    @objc dynamic var name = ""
    let owners = LinkingObjects(fromType: TestEntity.self, property: "pets")
}
