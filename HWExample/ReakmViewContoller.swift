//
//  ReakmViewContoller.swift
//  HWExample
//
//  Created by Александр Арсенюк on 03.12.2021.
//

import Foundation
import Realm
import RealmSwift

class RealmViewContoller: UIViewController {
    
    var token: NotificationToken?
    
    override func viewDidLoad() {
        
    }
    
    func realmNotificationPropertyTest() {
        let realm = try! Realm()
        guard let stepCounter = realm.objects(StepCounter.self).last else { return }
    
        let serialQueue = DispatchQueue(label: "some")
        
        token = stepCounter.observe(on: serialQueue) { change in
            switch change {
            case let .change(object, properties):
                print(properties)
            case let .error(error):
                print(error)
            case .deleted:
                print("object deleted")
            }
        }
        
        do {
            let realm = try Realm()
            realm.beginWrite()
            stepCounter.steps += 1
            try realm.commitWrite()
        } catch {
            print(error)
        }
        
    }
    
    func realmNotificationCollectionTest() {
        do {
            let configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
            let realm = try Realm(configuration: configuration)
            let dogs = realm.objects(Dog.self)
            
            self.token = dogs.observe({ changes in
                switch changes {
                case .initial(let results):
                    print("initial \(results)")
                case let .update(results, deletions, insertions, modifications):
                    print("updated \(results)")
                case let .error(error):
                    print(error)
                }
            })
            
            realm.beginWrite()
            realm.add(Dog(value: ["DogNew", 3]))
            try realm.commitWrite()
            
        } catch {
            print(error)
        }
    }
    
}
