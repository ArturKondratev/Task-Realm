//
//  RealmCashService.swift
//  Rubetek
//
//  Created by Артур Кондратьев on 08.07.2022.
//

import Foundation
import RealmSwift

class RealmCashService {
    
    var realm: Realm
    
    enum Errors: Error {
        case noRealmObject(String)
        case noPrimaryKeys(String)
        case failedToRead(String)
    }
    
    init() {
        do {
            // let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
            //self.realm = try Realm(configuration: config)
            
            self.realm = try Realm()
            print(realm.configuration.fileURL ?? "")
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func create<T: Object>(_ objects: [T]) {
        do {
            realm = try Realm()
            try realm.write {
                objects.forEach { realm.add($0)}
            }
        } catch {
            print(error)
        }
    }
    
//    func read<T: Object>(_ object: T.Type) -> Results<T> {
//        return realm.objects(T.self)
//    }
    
    func read<T: Object>(_ object: T.Type) -> [T] {
        let object = Array(realm.objects(T.self))
        return object
    }
    
    func update<T: Object>(_ objects: [T]) {
        do {
            realm = try Realm()
            try realm.write {
                objects.forEach { realm.add($0, update: .modified)}
            }
        } catch {
            print(error)
        }
    }
    
    func deleteObject<T: Object>(_ object: T) {
        try? realm.write {
            realm.delete(object)
        }
    }
    
    func deleteAll() {
        realm.beginWrite()
        realm.deleteAll()
        try? realm.commitWrite()
    }
    
}
