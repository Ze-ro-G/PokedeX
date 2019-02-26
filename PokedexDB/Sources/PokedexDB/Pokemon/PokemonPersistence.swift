//
//  PokemonPersistence.swift
//  CHTTPParser
//
//  Created by Tom Cajot on 08/01/2019.
//

import Foundation
import CouchDB
// 1
import SwiftyJSON

extension Pokemon {
    // 2
    class Persistence {
        
        static func getAll(from database: Database,
                           callback: @escaping (_ pokemons: [Pokemon]?, _ error: NSError?) -> Void) {
            database.retrieveAll(includeDocuments: true) { documents, error in
                guard let documents = documents else {
                    callback(nil, error)
                    return
                }
                var pokemons: [Pokemon] = []
                for document in documents["rows"].arrayValue {
                    let id = document["id"].stringValue
                    let name = document["doc"]["name"].stringValue
                    let number = document["doc"]["number"].stringValue
                    let type = document["doc"]["type"].stringValue
                    let abilities = document["doc"]["abilities"].stringValue
                    let description = document["doc"]["description"].stringValue
                    if let pokemon = Pokemon(id: id, name: name, number: number, type: type, abilities: abilities, description: description) {
                        pokemons.append(pokemon)
                    }
                }
                callback(pokemons, nil)
            }
        }
        
        
        static func getOne(with number: String, from database: Database,
                           callback: @escaping (_ pokemons: Pokemon?, _ error: NSError?) -> Void) {
            database.retrieveAll(includeDocuments: true) { documents, error in
                guard let documents = documents else {
                    callback(nil, error)
                    return
                }
                for document in documents["rows"].arrayValue {
                    let id = document["id"].stringValue
                    let name = document["doc"]["name"].stringValue
                    let numberPokemon = document["doc"]["number"].stringValue
                    let type = document["doc"]["type"].stringValue
                    let abilities = document["doc"]["abilities"].stringValue
                    let description = document["doc"]["description"].stringValue
                    if number == numberPokemon {
                        if let pokemon = Pokemon(id: id, name: name, number: number, type: type, abilities: abilities, description: description) {
                            callback(pokemon, nil)
                        }
                    }
                }
                callback(nil, nil)
            }
        }
        
        
        static func save(_ pokemon: Pokemon, to database: Database,
                         callback: @escaping (_ id: String?, _ error: NSError?) -> Void) {
            getAll(from: database) { pokemons, error in
                guard let pokemons = pokemons else {
                    return callback(nil, error)
                }
                // 3
                guard !pokemons.contains(pokemon) else {
                    return callback(nil, NSError(domain: "Kitura-TIL",
                                                 code: 400,
                                                 userInfo: ["localizedDescription": "Duplicate entry"]))
                }
                database.create(JSON(["name": pokemon.name, "number": pokemon.number, "type": pokemon.type, "abilities": pokemon.abilities, "description": pokemon.description])) { id, _, _, error in
                    callback(id, error)
                }
            }
        }
        
        // 4
        static func get(from database: Database, with id: String,
                        callback: @escaping (_ pokemon: Pokemon?, _ error: NSError?) -> Void) {
            database.retrieve(id) { document, error in
                guard let document = document else {
                    return callback(nil, error)
                }
                guard let pokemon = Pokemon(id: document["_id"].stringValue,
                                            name: document["name"].stringValue,
                                            number: document["number"].stringValue,
                                            type: document["type"].stringValue,
                                            abilities: document["abilities"].stringValue,
                                            description: document["description"].stringValue) else {
                                                return callback(nil, error)
                }
                callback(pokemon, nil)
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

