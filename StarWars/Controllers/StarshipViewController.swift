//
//  StarshipViewController.swift
//  StarWars
//
//  Created by Habibur Rahman on 4/30/24.
//

import UIKit
import Combine

class StarshipViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var tableView: UITableView!
    let homeViewModel = HomeViewModel.sharedInstance
    var viewModel = StarshipViewModel()
    var starships: [ResultOfStarship]?
    private var cancellable: Set<AnyCancellable> = []
    var pageNumber = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 12
        title = "Starship"
        view.backgroundColor = .clear
        DispatchQueue.global(qos: .default).async {
            self.viewModel.updateStarShipse(pageNumber: self.pageNumber)
            self.bindViewModelForStarShips()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return starships?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StarshipCell", for: indexPath)
        cell.textLabel?.text = String(describing: starships?[indexPath.row].name ?? "")
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let starshipDetailVC = storyboard?.instantiateViewController(identifier: "StarshipDetailVC") as? StarshipDetailViewController {
            starshipDetailVC.indexPath = indexPath.row
            navigationController?.pushViewController(starshipDetailVC, animated: true)
        }
    }

    private func bindViewModelForStarShips() {
        viewModel.$starShips
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { value in
                if let value = value {
                    self.updateUIForPeople(starships: value)
                }
            }.store(in: &cancellable)
    }

    func updateUIForPeople(starships: [ResultOfStarship]) {
        self.starships = starships
        homeViewModel.starships = starships
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
