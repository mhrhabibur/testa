//
//  StarshipViewModel.swift
//  StarWars
//
//  Created by Habibur Rahman on 04-05-2024.
//

import Foundation
import Alamofire
import Combine

class StarshipViewModel {

    public static let sharedInstance = StarshipViewModel()
    let homeViewModel = HomeViewModel.sharedInstance
    @Published private(set) var starShips:[ResultOfStarship]!
    var pageNumber: Int?

    func updateStarShipse(pageNumber: Int) {
        getStarship(page: pageNumber) { starship, error in
            guard let fetchedStarship = starship else {
                // Handle error here if needed
                print("Error fetching people: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            DispatchQueue.global().asyncAfter(deadline: .now() + 0) { [weak self] in
                self?.starShips = fetchedStarship.results
            }
        }
    }

    func getStarship(page: Int, completion: @escaping (Starship?, Error?)->()) {
        let url = "https://swapi.dev/api/starships/?page=\(page)"
        ApiService.sharedInstance.fetchAPIRequest(
            url: url,
            method: .get,
            encoding:.default) { (response: Starship?, error) in
                if let starship = response {
                    completion(starship, nil)
                }
            }
    }
}

