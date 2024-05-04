//
//  HomeViewModel.swift
//  StarWars
//
//  Created by Habibur Rahman on 04-05-2024.
//

import Foundation

class HomeViewModel {
    public static let sharedInstance = HomeViewModel()
    var people: [Character]?
    var planets: [ResultOfPlanet]?
    var starships: [ResultOfStarship]?
}
