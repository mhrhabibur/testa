//
//  ViewController.swift
//  StarWars
//
//  Created by Habibur Rahman on 4/25/24.
//

import UIKit
import CoreData

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let rightSizeImageViewForPassword = UIButton(frame: CGRect(x: -5.0, y: 10.0, width: 30, height: 20))
    var isIconClicked = true
    var isIconClickedForConfirmPassword = true
    var users: [NSManagedObject] = []
    var userData: Set<[String: String]> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.layer.masksToBounds = true
        signInButton.layer.borderWidth = CGFloat(Constants.BORDER_WIDTH)
        signInButton.layer.borderColor = Constants.BORDER_COLOR
        signInButton.layer.cornerRadius = CGFloat(Constants.BUTTON_CORNER_RADIUS)
        signUpButton.layer.masksToBounds = true
        signUpButton.layer.borderWidth = CGFloat(Constants.BORDER_WIDTH)
        signUpButton.layer.borderColor = Constants.BORDER_COLOR
        signUpButton.layer.cornerRadius = CGFloat(Constants.BUTTON_CORNER_RADIUS)
        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.placeholder = "Email"
        passwordTextField.placeholder = "Password"
        rightSizeImageViewForPassword.setImage(UIImage(systemName: "eye"), for: .normal)
        addRightSideImageForPassword(textField: passwordTextField)
    }

    @IBAction func signInButtonTapped(_ sender: UIButton) {

        guard let emailText = emailTextField.text, let passwordText = passwordTextField.text  else {
            return
        }

        guard (!emailText.isEmpty && !emailText.hasPrefix(" ")) && (!passwordText.isEmpty && !passwordText.hasPrefix(" ")) else {
            if emailText.isEmpty && passwordText.isEmpty {
                emailTextField.placeholder = "Enter You Email"
                passwordTextField.placeholder = "Enter You Password"
            } else if emailText.isEmpty {
                emailTextField.placeholder = "Enter You Email"
            } else if passwordText.isEmpty {
                passwordTextField.placeholder = "Enter You Password"
            }
            return
        }

        guard (fetchUserData(forEmail: emailText) == emailText) && (fetchPasswordData() == passwordText) else {
            let alert = UIAlertController(title: "Alert", message: "Email or Password is incorrect.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            present(alert, animated: true)
            return
        }
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
        emailTextField.text = ""
        passwordTextField.text = ""
        if let homeVC = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
            navigationController?.pushViewController(homeVC, animated: true)
        }
    }

    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
        if let signUpVC = storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as? SignUpViewController {
            navigationController?.pushViewController(signUpVC, animated: true)
        }
    }

    func addRightSideImageForPassword(textField: UITextField) {
        let iconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 35))
        iconContainerView.addSubview(rightSizeImageViewForPassword)
        rightSizeImageViewForPassword.tintColor = .gray
        textField.rightView = iconContainerView
        rightSizeImageViewForPassword.addTarget(self, action: #selector(showPassword), for: .touchUpInside)
        textField.rightViewMode = .always
    }

    @objc func showPassword() {
        if isIconClicked {
            passwordTextField.isSecureTextEntry = false
            rightSizeImageViewForPassword.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        } else {
            passwordTextField.isSecureTextEntry = true
            rightSizeImageViewForPassword.setImage(UIImage(systemName: "eye"), for: .normal)
        }
        isIconClicked = !isIconClicked
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
        return true
    }

    func fetchUserData(forEmail email: String) -> String? {
        var emailID: String?
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Error: AppDelegate is nil")
            return nil
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserInfo")
        do {
            let users = try managedContext.fetch(fetchRequest)
            var userData = [String: String]()
            for user in users {
                if let userEmail = user.value(forKeyPath: "email") as? String {
                    userData[userEmail] = userEmail
                }
            }
            if let userDataForEmail = userData[email] {
                emailID = userDataForEmail
            }
        } catch let error as NSError {
            print("Could not fetch user data: \(error), \(error.userInfo)")
        }
        return emailID
    }

    private func fetchPasswordData() -> String{
            var passwordText: String = ""
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return ""
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserInfo")
            do {
                users = try managedContext.fetch(fetchRequest)
                for user in users {
                    userData.insert([user.value(forKeyPath: "password") as! String: user.value(forKeyPath: "password") as! String])
                }
                for info in userData {
                    if let userInfo = info["\(passwordTextField.text!)"] {
                        passwordText = userInfo
                    }
                }
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
            return passwordText
        }
}

