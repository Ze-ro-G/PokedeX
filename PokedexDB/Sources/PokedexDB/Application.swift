//
//  Application.swift
//  CHTTPParser
//
//  Created by Tom Cajot on 08/01/2019.
//

// 1
import CouchDB
import Foundation
import Kitura
import LoggerAPI

public class App {
    
    // 2
    var client: CouchDBClient?
    var database: Database?
    
    let router = Router()
    
    private func postInit() {
        // 1
        let connectionProperties = ConnectionProperties(host: "localhost", port: 5984, secured: false)
        client = CouchDBClient(connectionProperties: connectionProperties)
        // 2
        client!.dbExists("pokedex") { exists, _ in
            guard exists else {
                // 3
                self.createNewDatabase()
                return
            }
            // 4
            Log.info("Database located - loading...")
            self.finalizeRoutes(with: Database(connProperties: connectionProperties, dbName: "pokedex"))
        }

    }
    
    private func createNewDatabase() {
        Log.info("Database does not exist - creating new database")
        // 1
        client?.createDB("pokedex") { database, error in
            // 2
            guard let database = database else {
                let errorReason = String(describing: error?.localizedDescription)
                Log.error("Could not create new database: (\(errorReason)) - pokemon routes not created")
                return
            }
            self.finalizeRoutes(with: database)
        }

    }
    
    private func finalizeRoutes(with database: Database) {
        self.database = database
        initializePokemonRoutes(app: self)
        initializeBadgeRoutes(app: self)
        Log.info("Pokemon routes created")
        Log.info("Badge routes created")

    }
    
    public func run() {
        // 6
        postInit()
        Kitura.addHTTPServer(onPort: 8180, with: router)
        Kitura.run()
    }
}


//curl -X POST http://localhost:8180/pokemons -H 'content-type: application/json' -d '{"name": "Wartortle", "number": "8", "type": "Water", "abilities": "Torrent", "description": "gety"}'
