//
//  PokemonRoutes.swift
//  KituraTIL
//
//  Created by Tom Cajot on 08/01/2019.
//

import CouchDB
import Kitura
import KituraContracts
import LoggerAPI

private var database: Database?

func initializePokemonRoutes(app: App) {
    database = app.database
    // 1
    app.router.get("/pokemons", handler: getPokemons)
    app.router.post("/pokemons", handler: addPokemon)
    app.router.delete("/pokemons", handler: deletePokemon)
    app.router.get("/pokemon", handler: getPokemon)
}

// 2
private func getPokemons(completion: @escaping ([Pokemon]?, RequestError?) -> Void) {
    guard let database = database else {
        return completion(nil, .internalServerError)
    }
    Pokemon.Persistence.getAll(from: database) { pokemons, error in
        return completion(pokemons, error as? RequestError)
    }
}


private func getPokemon(number: String, completion: @escaping (Pokemon?, RequestError?) -> Void) {
    guard let database = database else {
        return completion(nil, .internalServerError)
    }
    Pokemon.Persistence.getOne(with: number, from: database) { (pokemon, error) in
        return completion(pokemon, error as? RequestError)
    }
    
}



// 3
private func addPokemon(pokemon: Pokemon, completion: @escaping (Pokemon?, RequestError?) -> Void) {
    guard let database = database else {
        return completion(nil, .internalServerError)
    }
    Pokemon.Persistence.save(pokemon, to: database) { id, error in
        guard let id = id else {
            return completion(nil, .notAcceptable)
        }
        Pokemon.Persistence.get(from: database, with: id) { newPokemon, error in
            return completion(newPokemon, error as? RequestError)
        }
    }
}

// 4

private func deletePokemon(id: String, completion: @escaping (RequestError?) -> Void) {
    guard let database = database else {
        return completion(.internalServerError)
    }
    Pokemon.Persistence.delete(with: id, from: database) { error in
        return completion(error as? RequestError)
    }
}


