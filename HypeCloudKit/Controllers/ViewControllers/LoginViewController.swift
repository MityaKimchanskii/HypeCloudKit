//
//  LoginViewController.swift
//  HypeCloudKit
//
//  Created by Mitya Kim on 6/13/22.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - Properties
    var profilePhoto: UIImage?
    
    // MARK: - Outlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    @IBOutlet weak var pickerContainerView: UIView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        setupViews()
    }
    
    // MARK: - Actions
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let username = usernameTextField.text, !username.isEmpty,
              let bio = bioTextField.text
        else { return }
        
        UserController.shared.createUser(with: username, bio: bio, profilePhoto: profilePhoto) { success in
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
    
    func setupViews() {
        pickerContainerView.layer.cornerRadius = pickerContainerView.frame.height / 2
        pickerContainerView.clipsToBounds = true
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photoSegue" {
            let destinationVC = segue.destination as? PhotoPickerViewController
            destinationVC?.delegate = self
        }
    }
}

// MARK: - Extensions
extension LoginViewController: PhotoPickerDelegate {
    func photoPickerSelected(image: UIImage) {
        self.profilePhoto = image
    }
}
