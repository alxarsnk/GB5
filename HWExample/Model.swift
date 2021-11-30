//
//  Model.swift
//  HWExample
//
//  Created by Александр Арсенюк on 30.11.2021.
//

import Foundation
import RealmSwift
import Realm

@objcMembers
class VKFriendResponse: Object, Codable {
    dynamic var response: VKFriendResponseData? = nil
}

@objcMembers
class VKFriendResponseData: Object, Codable {
    dynamic var count: Int = 0
    dynamic var items = List<Friend>()
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        count = try container.decode(Int.self, forKey: .count)
        let itemsList = try container.decode([Friend].self, forKey: .items)
        items.append(objectsIn: itemsList)
        super.init()
    }
    
    required override init() {
        super.init()
    }
}

@objcMembers
class Friend: Object, Codable {
    dynamic var id: Int
    dynamic var city: City?
    dynamic var firstName: String
    dynamic var lastName: String
    dynamic var canAccessClosed: Bool?
    dynamic var isCLosed: Bool?
    dynamic var sex: Int
    dynamic var domain: String
    dynamic var bdate: String?
    dynamic var deactivated: String?
    dynamic var trackCode: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case city
        case firstName = "first_name"
        case lastName = "last_name"
        case canAccessClosed = "can_access_closed"
        case isCLosed = "is_closed"
        case sex
        case domain
        case bdate
        case deactivated
        case trackCode = "track_code"
    }
    
}

@objcMembers
class City: Object, Codable {
    dynamic var id: Int
    dynamic var title: String
}

