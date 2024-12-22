//
//  DetailEpisode.swift
//  RAM
//
//  Created by Aaa on 01.09.2024.
//

import Foundation

struct DetailMock {
    let name: String
    let image: String
    let nameEpisode: Episode
}


//MARK: Singleton Pattern
//что означает, что у этого класса будет только один экземпляр в приложении shared
//class DataMock {
//    static let shared = DataMock()
//    
//    let character = [
//        DetailMock(name: "Rick", image: "Image", nameEpisode: Episode(name: "Pilot", numberEpisode: "S01E01")),
//        DetailMock(name: "Morty", image: "Image 1", nameEpisode: Episode(name: "Lawnmower Dog", numberEpisode: "S01E02")),
//        DetailMock(name: "Bet Morty", image: "Image 2", nameEpisode: Episode(name: "Anatomy Park", numberEpisode: "S01E03")),
//        DetailMock(name: "Rick", image: "Image", nameEpisode: Episode(name: "Pilot", numberEpisode: "S01E01")),
//        DetailMock(name: "Morty", image: "Image 1", nameEpisode: Episode(name: "Lawnmower Dog", numberEpisode: "S01E02")),
//        DetailMock(name: "Bet Morty", image: "Image 2", nameEpisode: Episode(name: "Anatomy Park", numberEpisode: "S01E03"))
//    ]
//    
//    private init(){}
//    
//}
//Эти строки кода гарантируют, что создать новый экземпляр класса DataMock можно только внутри самого класса, и доступ к нему можно получить через DataMock.shared.
