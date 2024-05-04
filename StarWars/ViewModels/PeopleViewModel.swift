//
//  PeopleViewModel.swift
//  StarWars
//
//  Created by Habibur Rahman on 04-05-2024.
//
//
import Foundation
import Alamofire
import Combine

class PeopleViewModel {

    public static let sharedInstance = PeopleViewModel()
    let homeViewModel = HomeViewModel.sharedInstance
    @Published private(set) var people:[Character]!
    var pageNumber: Int?

    func updatePeople(pageNumber: Int) {
        getPeople(page: pageNumber) { people, error in
            guard let fetchedPeople = people else {
                print("Error fetching people: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            DispatchQueue.global().asyncAfter(deadline: .now() + 0) { [weak self] in
                self?.people = fetchedPeople.results
            }
        }
    }

    func getPeople(page: Int, completion: @escaping (People?, Error?)->()) {
        let url = "https://swapi.dev/api/people/?page=\(page)"
        ApiService.sharedInstance.fetchAPIRequest(
            url: url,
            method: .get,
            encoding:.default) { (response: People?, error) in
                if let people = response {
                    completion(people, nil)
                }
            }
    }
}
