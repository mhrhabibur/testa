//
//  People.swift
//  StarWars
//
//  Created by Habibur Rahman on 4/29/24.
//

import Foundation
import Foundation

struct People: Codable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [Character]?
}

struct Character: Codable {
    let name: String?
    let height: String?
    let mass: String?
    let hairColor: String?
    let skinColor: String?
    let eyeColor: String?
    let birthYear: String?
    let gender: String?
    let homeWorld: String?
    let films: [String]?
    let species: [String]?
    let vehicles: [String]?
    let starships: [String]?
    let created: String?
    let edited: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case name, height, mass
        case hairColor = "hair_color"
        case skinColor = "skin_color"
        case eyeColor = "eye_color"
        case birthYear = "birth_year"
        case homeWorld = "homeworld"
        case gender
        case films
        case species
        case vehicles
        case starships
        case created
        case edited
        case url
    }
}

//enum Gender: String, Codable {
//    case female = "female"
//    case male = "male"
//    case nA = "n/a"
//}
