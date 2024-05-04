//
//  PeopleViewController.swift
//  StarWars
//
//  Created by Habibur Rahman on 4/30/24.
//

import UIKit
import Combine

class PeopleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    let homeViewModel = HomeViewModel.sharedInstance
    var viewModel = PeopleViewModel()
    var people: [Character]?
    private var cancellable: Set<AnyCancellable> = []
    var pageNumber = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 12
        title = "People"
        view.backgroundColor = .clear
        DispatchQueue.global(qos: .default).async {
            self.viewModel.updatePeople(pageNumber: self.pageNumber)
            self.bindViewModelForPeople()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleCell", for: indexPath)
        cell.textLabel?.text = String(describing: people?[indexPath.row].name ?? "")
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let peopleDetailVC = storyboard?.instantiateViewController(identifier: "PeopleDetailVC") as? PeopleDetailViewController {
            peopleDetailVC.indexPath = indexPath.row
            navigationController?.pushViewController(peopleDetailVC, animated: true)
        }
    }

    private func bindViewModelForPeople() {
        viewModel.$people
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { value in
                if let value = value {
                    self.updateUIForPeople(people: value)
                }
            }.store(in: &cancellable)
    }

    func updateUIForPeople(people: [Character]) {
        self.people = people
        homeViewModel.people = people
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
