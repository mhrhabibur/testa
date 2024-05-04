//
//  Starship.swift
//  StarWars
//
//  Created by Habibur Rahman on 4/29/24.
//

import Foundation

struct Starship: Codable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [ResultOfStarship]?
}


struct ResultOfStarship: Codable {
    let name, model, manufacturer, costInCredits: String?
    let length: String?
    let maxAtmospheringSpeed: String?
    let crew: String?
    let passengers: String?

    let cargoCapacity: String?
    let consumables: String?
    let hyperdriveRating: String?
    let mglt: String?
    let starshipClass: String?
    let pilots: [String]?
    let films: [String]?
    let created: String?
    let edited: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case name
        case model
        case manufacturer
        case costInCredits = "cost_in_credits"
        case length
        case maxAtmospheringSpeed = "max_atmosphering_speed"
        case crew
        case passengers
        case cargoCapacity = "cargo_capacity"
        case consumables
        case hyperdriveRating = "hyperdrive_rating"
        case mglt = "MGLT"
        case starshipClass = "starship_class"
        case pilots
        case films
        case created
        case edited
        case url
    }
}
