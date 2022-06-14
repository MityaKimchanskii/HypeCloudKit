//
//  LoginViewController.swift
//  HypeCloudKit
//
//  Created by Mitya Kim on 6/13/22.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
    }
    
    // MARK: - Actions
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let username = usernameTextField.text, !username.isEmpty,
              let bio = bioTextField.text
        else { return }
        
        UserController.shared.createUser(with: username, bio: bio) { success in
            if success {
                self.presentHypeListViewController()
            }
        }
    }
    
    // MARK: - Helper Methods
    func fetchUser() {
        UserController.shared.fetchUser { success in
            if success {
                self.presentHypeListViewController()
            }
        }
    }
    
    func presentHypeListViewController() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "HypeList", bundle: nil)
            guard let viewController = storyboard.instantiateInitialViewController() else { return }
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true)
        }
    }
}
