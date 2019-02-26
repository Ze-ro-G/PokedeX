//
//  Badge.swift
//  KituraTIL
//
//  Created by Tom Cajot on 15/01/2019.
//


// 1
struct Badge: Codable {
    
    var id: String?
    var name: String
    var number: String
    var champion: String
    var ville: String
    var type: String
    var effets: String
    
    
    init?(id: String?, name: String, number: String, champion: String, ville: String, type: String, effets: String) {
        // 2
        if name.isEmpty || number.isEmpty || champion.isEmpty || ville.isEmpty || type.isEmpty || effets.isEmpty {
            return nil
        }
        self.id = id
        self.name = name
        self.number = number
        self.champion = champion
        self.ville = ville
        self.type = type
        self.effets = effets
    }
}

// 3
extension Badge: Equatable {
    
    public static func == (lhs: Badge, rhs: Badge) -> Bool {
        return lhs.name == rhs.name && lhs.number == rhs.number && lhs.champion == rhs.champion && lhs.ville == rhs.ville && lhs.type == rhs.type && lhs.effets == rhs.effets
    }
}

