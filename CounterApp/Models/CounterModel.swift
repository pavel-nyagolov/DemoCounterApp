//
//  Counting.swift
//  CounterApp
//
//  Created by Pavel on 6.04.23.
//

import UIKit
import RealmSwift

class CounterModel: Object, ObjectKeyIdentifiable, Codable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var emoji: String
    @Persisted var title: String
    @Persisted var count: Int = 0
}
