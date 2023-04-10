//
//  FactoryStorage.swift
//  CounterApp
//
//  Created by Pavel on 6.04.23.
//

import Foundation
import RealmSwift

class FactoryStorage {
    static let realm = try! Realm(configuration: realmConfig)
    
    static var realmConfig: Realm.Configuration {
        var config = Realm.Configuration()
        config.deleteRealmIfMigrationNeeded = true
        config.schemaVersion = 1
        return config
    }
    
    static func addCounter(_ counter: CounterModel) {
        FactoryStorage.realm.beginWrite()
        FactoryStorage.realm.add(counter)
        try? FactoryStorage.realm.commitWrite()
        NotificationCenter.default.post(name: .updateData, object: nil)
    }
    
    static func deleteCounter(_ counter: CounterModel) {
        FactoryStorage.realm.beginWrite()
        FactoryStorage.realm.delete(counter)
        try? FactoryStorage.realm.commitWrite()
        NotificationCenter.default.post(name: .updateData, object: nil)
    }
    
    static func getCounters() -> [CounterModel]? {
        return Array(FactoryStorage.realm.objects(CounterModel.self).sorted(byKeyPath: "id", ascending: true))
    }
}
