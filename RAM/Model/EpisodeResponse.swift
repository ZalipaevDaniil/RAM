//
//  EpisodeResponse.swift
//  RAM
//
//  Created by Aaa on 01.09.2024.
//

import Foundation
struct EpisodesResponse: Decodable, Equatable {
    let info: InfoEpisode
    let results : [CharacterResponse]
}


