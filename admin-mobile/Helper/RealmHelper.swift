//
//  RealmHelper.swift
//  mobile
//
//  Created by NguyenSon_MP on 02/04/2023.
//

import Foundation
import RealmSwift

public final class WriteTransaction {
    private let realm: Realm
    internal init(realm: Realm) {
        self.realm = realm
    }
    public func add<T: Persistable>(_ value: T, update: Bool) {
        if update {
            realm.add(value.managedObject(), update: .all)
        } else {
            realm.add(value.managedObject(), update: .error)
        }
    }
    
    
    public func get<T: Object>(_ value: T.Type) -> Results<T> {
        let data = realm.objects(T.self)
        return data
    }

    public func deleteAll<T: Object>(_ value: T.Type) {
//        if value == DataMyTicketObject.self {
//            let all = realm.objects(DataMyTicketObject.self)
////            all.forEach{idx in
////
////                if let session = idx.session {
////                    if let event = session.event {
////                        realm.delete(event)
////                        if let user = event.user {
////                            realm.delete(user)
////                        }
////                    }
////                    realm.delete(session)
////                }
////                if let buyer = idx.buyer {
////                    realm.delete(buyer)
////                }
////                if let owner = idx.owner {
////                    realm.delete(owner)
////                }
////            }
//
//            realm.deleteAll()
//            realm.delete(all)
//        } else {
//            let all = realm.objects(T.self)
//            realm.delete(all)
//        }
//
        
        realm.deleteAll()
    }
    
    
    public func objectExist<T: Object>(_ value: T.Type) -> Bool {
        return realm.objects(T.self).isEmpty
    }
    
}

// Implement the Container
public final class Container {
//    static let containerInstance = try! Container()
    private let realm: Realm
    public convenience init() throws {
        try self.init(realm: Realm())
    }
    internal init(realm: Realm) {
        self.realm = realm
    }
    public func write(_ block: (WriteTransaction) throws -> Void)
    throws {
        let transaction = WriteTransaction(realm: realm)
        try realm.safeWrite {
            try block(transaction)
        }
    }
//    
//    public func get<T: Object>(_ value: T.Type) -> Results<T> {
//        let data = realm.objects(T.self)
//        return data
//    }
//    
//    public func deleteAll<T: Object>(_ value: T.Type) {
//        throws {
//            let transaction = WriteTransaction(realm: realm)
//            try realm.write {
//                let all = realm.objects(T.self)
//                realm.delete(all)
//            }
//        }
//    }
    

}
