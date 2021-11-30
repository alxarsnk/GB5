//
//  Session.swift
//  HWExample
//
//  Created by Александр Арсенюк on 30.11.2021.
//

import Foundation

class Session {
    
    private init() { }
    
    static let shared = Session()
    
    var token: String = ""
}
