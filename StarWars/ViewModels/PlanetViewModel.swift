//
//  PlanetViewModel.swift
//  StarWars
//
//  Created by Habibur Rahman on 04-05-2024.
//


import Foundation
import Alamofire
import Combine

class PlanetViewModel {

    public static let sharedInstance = PlanetViewModel()
    let homeViewModel = HomeViewModel.sharedInstance
    @Published private(set) var planets:[ResultOfPlanet]!
    var pageNumber: Int?

    func updatePlanet(pageNumber: Int) {
        getPlanet(page: pageNumber) { planets, error in
            guard let fetchedPlanets = planets else {
                print("Error fetching people: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            DispatchQueue.global().asyncAfter(deadline: .now() + 0) { [weak self] in
                self?.planets = fetchedPlanets.results
            }
        }
    }

    func getPlanet(page: Int, completion: @escaping (Planet?, Error?)->()) {
        let url = "https://swapi.dev/api/planets/?page=\(page)"
        ApiService.sharedInstance.fetchAPIRequest(
            url: url,
            method: .get,
            encoding:.default) { (response: Planet?, error) in
                if let planets = response {
                    completion(planets, nil)
                }
            }
    }
}


