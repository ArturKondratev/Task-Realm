//
//  DoorsRealm.swift
//  Rubetek
//
//  Created by Артур Кондратьев on 08.07.2022.
//

import Foundation
import RealmSwift

class DoorsRealmModel: Object {

    @Persisted var name: String
    @Persisted var room: String?
    @Persisted(primaryKey: true) var id: Int
    @Persisted var favorites: Bool
    @Persisted var snapshot: String?
}
