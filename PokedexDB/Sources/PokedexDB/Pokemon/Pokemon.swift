//
//  Pokemon.swift
//  CHTTPParser
//
//  Created by Tom Cajot on 08/01/2019.
//

// 1
struct Pokemon: Codable {
    
    var id: String?
    var name: String
    var number: String
    var type: String
    var abilities: String
    var description: String
    
    
    init?(id: String?, name: String, number: String, type: String, abilities: String, description: String) {
        // 2
        if name.isEmpty || number.isEmpty || type.isEmpty || abilities.isEmpty || description.isEmpty {
            return nil
        }
        self.id = id
        self.name = name
        self.number = number
        self.type = type
        self.abilities = abilities
        self.description = description
    }
}

// 3
extension Pokemon: Equatable {
    
    public static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
        return lhs.name == rhs.name && lhs.number == rhs.number && lhs.type == rhs.type && lhs.abilities == rhs.abilities && lhs.description == rhs.description
    }
}

