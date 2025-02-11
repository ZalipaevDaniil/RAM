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

struct EpisodeResult: Codable, Equatable {
    var id: Int
    let name: String
    let air_date: String
    let numberEpisode: String
    let characters: [String]
    let url : String
    let created : String
    private enum CodingKeys: String, CodingKey {
        case id, name, air_date, characters, url, created
        case numberEpisode = "episode"
    }
    static func == (lhs: EpisodeResult, rhs: CharacterResult) -> Bool {
        return lhs.id == rhs.id
    }
    
}
