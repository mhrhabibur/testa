//
//  PlanetViewController.swift
//  StarWars
//
//  Created by Habibur Rahman on 4/30/24.
//

import UIKit
import Combine

class PlanetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var tableView: UITableView!
    let homeViewModel = HomeViewModel.sharedInstance
    var viewModel = PlanetViewModel()
    var planets: [ResultOfPlanet]?
    private var cancellable: Set<AnyCancellable> = []
    var pageNumber = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 12
        title = "Planets"
        view.backgroundColor = .clear

        DispatchQueue.global(qos: .default).async {
            self.viewModel.updatePlanet(pageNumber: self.pageNumber)
            self.bindViewModelForSPlanet()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return planets?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlanetCell", for: indexPath)
        cell.textLabel?.text = String(describing: planets?[indexPath.row].name ?? "")
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let planetDetailVC = storyboard?.instantiateViewController(identifier: "PlanetDetailVC") as? PlanetDetailViewController {
            planetDetailVC.indexPath = indexPath.row
            navigationController?.pushViewController(planetDetailVC, animated: true)
        }
    }

    private func bindViewModelForSPlanet() {
        viewModel.$planets
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { value in
                if let value = value {
                    self.updateUIForPlanet(planets: value)
                }
            }.store(in: &cancellable)
    }

    func updateUIForPlanet(planets: [ResultOfPlanet]) {
        self.planets = planets
        homeViewModel.planets = planets
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
