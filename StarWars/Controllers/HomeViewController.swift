//
//  HomeViewController.swift
//  StarWars
//
//  Created by Habibur Rahman on 4/29/24.

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var peopleView: UIView!
    @IBOutlet weak var starshipView: UIView!
    @IBOutlet weak var planetView: UIView!
    var indexNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showToast("Login Successfully")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .done, target: self, action: #selector(navigateToProfile))
        segmentedControl.layer.borderColor = UIColor.lightGray.cgColor
        segmentedControl.layer.borderWidth = CGFloat(0.2)
        segmentedControl.selectedSegmentIndex = indexNumber
        segmentedControlTapped(segmentedControl)
    }

    @IBAction func segmentedControlTapped(_ sender: UISegmentedControl) {
        peopleView.isHidden = true
        starshipView.isHidden = true
        planetView.isHidden = true

        switch sender.selectedSegmentIndex {
        case 0:
            peopleView.isHidden = false
            sender.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
            sender.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "People", style: .plain, target: self, action: nil)
            navigationItem.leftBarButtonItem?.tintColor = .white
        case 1:
            starshipView.isHidden = false
            sender.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
            sender.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Starship", style: .plain, target: self, action: nil)
            navigationItem.leftBarButtonItem?.tintColor = .white
        case 2:
            planetView.isHidden = false
            sender.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
            sender.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Planet", style: .plain, target: self, action: nil)
            navigationItem.leftBarButtonItem?.tintColor = .white
        default:
            break
        }
    }

    @objc func navigateToProfile() {
        navigationController?.popToRootViewController(animated: true)
    }
}
