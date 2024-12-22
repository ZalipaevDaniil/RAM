//
//  NetworkError.swift
//  RAM
//
//  Created by Aaa on 01.09.2024.
//

import Foundation

enum NetworkError: LocalizedError {
    case decodingError(Error)
    case requestError(Error)
    case emptyData
    case cannotConvertImage
    case imageFetchingError
    case badURL
    
    public var errorDescription: String {
        switch self {
        case .decodingError(let error): 
            return "Error occured while decoding: \(error) "
        case .requestError(let error):
            return "Fetching error : \(error)"
        case .emptyData:
            return "Request returned an empty data"
        case .cannotConvertImage:
            return "Cannot convert image from data"
        case .imageFetchingError:
            return "Image fatching error"
        case .badURL:
            return "Cannot make a proper URL"
        }
    }
}
