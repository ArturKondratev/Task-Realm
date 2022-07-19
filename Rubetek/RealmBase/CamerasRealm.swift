//
//  CamerasRealm.swift
//  Rubetek
//
//  Created by Артур Кондратьев on 08.07.2022.
//

import Foundation
import RealmSwift

class CamerasRealmModel: Object {
  //  @Persisted(primaryKey: true) var key = UUID()
    
    @Persisted var name: String
    @Persisted var snapshot: String
    @Persisted var room: String?
    @Persisted(primaryKey: true) var id: Int
    @Persisted var favorites: Bool
    @Persisted var rec: Bool
}

