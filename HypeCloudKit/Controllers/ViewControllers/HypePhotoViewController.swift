//
//  HypePhotoViewController.swift
//  HypeCloudKit
//
//  Created by Mitya Kim on 6/14/22.
//

import UIKit

class HypePhotoViewController: UIViewController {
    
    // MARK: - Properties
    var image: UIImage?

    // MARK: - Outlets
    @IBOutlet weak var hypeTextField: UITextField!
    @IBOutlet weak var hypeContainerView: UIView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Actions
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismissView()
    }
    
    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        guard let text = hypeTextField.text, !text.isEmpty,
              let image = image
        else { return }
        
        HypeController.shared.createHype(with: text, photo: image) { success in
            if success {
                self.dismissView()
            }
        }
    }
    
    // MARK: - Helper Methods
    func dismissView() {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
    
    func setupViews() {
        hypeContainerView.layer.cornerRadius = hypeContainerView.frame.height / 10
        hypeContainerView.clipsToBounds = true
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
extension HypePhotoViewController: PhotoPickerDelegate {
    func photoPickerSelected(image: UIImage) {
        self.image = image
    }
}
