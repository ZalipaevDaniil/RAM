//
//  CharacterResponse.swift
//  RAM
//
//  Created by Aaa on 01.09.2024.
//

import Foundation

struct CharacterResponse: Codable, Equatable {
    var id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: Location
    let location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
    
    static func == (lhs: CharacterResponse, rhs: CharacterResponse) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Location
struct Location : Codable, Equatable {
    let name: String //name planet
    let url: String
}
