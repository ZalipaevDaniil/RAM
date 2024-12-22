//
//  InfoEpisode.swift
//  RAM
//
//  Created by Aaa on 01.09.2024.
//

import Foundation

struct InfoEpisode: Codable, Equatable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

struct Episode: Codable, Equatable {
    var id: Int
    let name: String
    let numberEpisode: String
    
    private enum CodingKeys: String, CodingKey {
        case id, name
        case numberEpisode = "episode"
    }
    static func == (lhs: Episode, rhs: CharacterResponse) -> Bool {
        return lhs.id == rhs.id
    }
    
}
