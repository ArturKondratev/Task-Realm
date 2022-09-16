//
//  CamerasRealm.swift
//  Rubetek
//
//  Created by Артур Кондратьев on 08.07.2022.
//

import Foundation
import RealmSwift

class CamerasRealmRoom: Object {
    
    @Persisted(primaryKey: true) var roomName: String
    @Persisted var cameras: List<CamerasRealmModel>
}

class CamerasRealmModel: Object {
    
    @Persisted var name: String
    @Persisted var snapshot: String
    @Persisted var room: String?
    @Persisted(primaryKey: true) var id: Int
    @Persisted var favorites: Bool
    @Persisted var rec: Bool
}

