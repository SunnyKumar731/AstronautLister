//
//  AstronautDataModels.swift
//  AstronautLister
//
//  Created by Sunny Kumar on 25/3/22.
//  Copyright © 2022 Sunny Kumar. All rights reserved.
//

import Foundation

struct AstronautInfo: Decodable {
    let id: Int
    let name: String
    let profileImageUrl: String
    let nationality: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profileImageUrl =  "profile_image_thumbnail"
        case nationality
    }
}

struct AstronautData: Decodable {
    let results: [AstronautInfo]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}

struct AstronautDetials: Decodable {
    let id: Int
    let profileImageUrl: String
    let name: String
    let dateOfBirth: String
    let bio: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case profileImageUrl = "profile_image"
        case name
        case dateOfBirth = "date_of_birth"
        case bio
    }
}

// All errors apart from parsing error are considered as network failure
enum DataError: Error {
    case networkFailure
    case parsingError
    case internalError
    case none
}
