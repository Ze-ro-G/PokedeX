//
//  BadgePersistence.swift
//  KituraTIL
//
//  Created by Tom Cajot on 15/01/2019.
//


import Foundation
import CouchDB
// 1
import SwiftyJSON

extension Badge {
    // 2
    class Persistence {
        
        static func getAll(from database: Database,
                           callback: @escaping (_ badges: [Badge]?, _ error: NSError?) -> Void) {
            database.retrieveAll(includeDocuments: true) { documents, error in
                guard let documents = documents else {
                    callback(nil, error)
                    return
                }
                var badges: [Badge] = []
                for document in documents["rows"].arrayValue {
                    let id = document["id"].stringValue
                    let name = document["doc"]["name"].stringValue
                    let number = document["doc"]["number"].stringValue
                    let champion = document["doc"]["champion"].stringValue
                    let ville = document["doc"]["ville"].stringValue
                    let type = document["doc"]["type"].stringValue
                    let effets = document["doc"]["effets"].stringValue

                    if let badge = Badge(id: id, name: name, number: number, champion: champion, ville: ville, type: type, effets: effets) {
                        badges.append(badge)
                    }
                }
                callback(badges, nil)
            }
        }
        
        
        static func getOne(with number: String, from database: Database,
                           callback: @escaping (_ badges: Badge?, _ error: NSError?) -> Void) {
            database.retrieveAll(includeDocuments: true) { documents, error in
                guard let documents = documents else {
                    callback(nil, error)
                    return
                }
                for document in documents["rows"].arrayValue {
                    let id = document["id"].stringValue
                    let name = document["doc"]["name"].stringValue
                    let numberBadge = document["doc"]["number"].stringValue
                    let champion = document["doc"]["champion"].stringValue
                    let ville = document["doc"]["ville"].stringValue
                    let type = document["doc"]["type"].stringValue
                    let effets = document["doc"]["effets"].stringValue
                    if number == numberBadge {
                        if let badge = Badge(id: id, name: name, number: number, champion: champion, ville: ville, type: type, effets: effets) {
                            callback(badge, nil)
                        }
                    }
                }
                callback(nil, nil)
            }
        }
        
        
        static func save(_ badge: Badge, to database: Database,
                         callback: @escaping (_ id: String?, _ error: NSError?) -> Void) {
            getAll(from: database) { badges, error in
                guard let badges = badges else {
                    return callback(nil, error)
                }
                // 3
                guard !badges.contains(badge) else {
                    return callback(nil, NSError(domain: "Kitura-TIL",
                                                 code: 400,
                                                 userInfo: ["localizedDescription": "Duplicate entry"]))
                }
                database.create(JSON(["name": badge.name, "number": badge.number, "champion": badge.champion, "ville": badge.ville, "type": badge.type, "effets": badge.effets])) { id, _, _, error in
                    callback(id, error)
                }
            }
        }
        
        // 4
        static func get(from database: Database, with id: String,
                        callback: @escaping (_ badge: Badge?, _ error: NSError?) -> Void) {
            database.retrieve(id) { document, error in
                guard let document = document else {
                    return callback(nil, error)
                }
                guard let badge = Badge(id: document["_id"].stringValue,
                                            name: document["name"].stringValue,
                                            number: document["number"].stringValue,
                                            champion: document["champion"].stringValue,
                                            ville: document["ville"].stringValue,
                                            type: document["type"].stringValue,
                                            effets: document["effets"].stringValue) else {
                                                return callback(nil, error)
                }
                callback(badge, nil)
            }
        }
        
        static func delete(with id: String, from database: Database,
                           callback: @escaping (_ error: NSError?) -> Void) {
            database.retrieve(id) { document, error in
                guard let document = document else {
                    return callback(error)
                }
                let id = document["_id"].stringValue
                // 5
                let revision = document["_rev"].stringValue
                database.delete(id, rev: revision) { error in
                    callback(error)
                }
            }
        }
    }
}

