//
//  BadgeRoutes.swift
//  KituraTIL
//
//  Created by Tom Cajot on 15/01/2019.
//

import CouchDB
import Kitura
import KituraContracts
import LoggerAPI

private var database: Database?

func initializeBadgeRoutes(app: App) {
    database = app.database
    // 1
    app.router.get("/badges", handler: getBadges)
    app.router.post("/badges", handler: addBadge)
    app.router.delete("/badges", handler: deleteBadge)
    app.router.get("/badge", handler: getBadge)
}

// 2
private func getBadges(completion: @escaping ([Badge]?, RequestError?) -> Void) {
    guard let database = database else {
        return completion(nil, .internalServerError)
    }
    Badge.Persistence.getAll(from: database) { badges, error in
        return completion(badges, error as? RequestError)
    }
}


private func getBadge(number: String, completion: @escaping (Badge?, RequestError?) -> Void) {
    guard let database = database else {
        return completion(nil, .internalServerError)
    }
    Badge.Persistence.getOne(with: number, from: database) { (badge, error) in
        return completion(badge, error as? RequestError)
    }
    
}



// 3
private func addBadge(badge: Badge, completion: @escaping (Badge?, RequestError?) -> Void) {
    guard let database = database else {
        return completion(nil, .internalServerError)
    }
    Badge.Persistence.save(badge, to: database) { id, error in
        guard let id = id else {
            return completion(nil, .notAcceptable)
        }
        Badge.Persistence.get(from: database, with: id) { newBadge, error in
            return completion(newBadge, error as? RequestError)
        }
    }
}

// 4

private func deleteBadge(id: String, completion: @escaping (RequestError?) -> Void) {
    guard let database = database else {
        return completion(.internalServerError)
    }
    Badge.Persistence.delete(with: id, from: database) { error in
        return completion(error as? RequestError)
    }
}



/*
 curl -X POST http://localhost:8080/acronyms -H 'content-type: application/json' -d '{"short": "BRB", "long": "Be right back"}'
 
 curl -X POST http://localhost:8080/badges -H 'content-type: application/json' -d '{"name": "BadgeRoche", "number": "1", "champion": "Pierre", "ville": "Argenta", "type": "Roche", "effets": "Fla"}'
*/

